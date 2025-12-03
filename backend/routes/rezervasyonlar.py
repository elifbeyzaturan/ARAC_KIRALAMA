import datetime
from flask import Blueprint, jsonify, request
from backend.db import get_connection
from backend.utils import token_required

rezervasyon_bp = Blueprint("rezervasyonlar", __name__, url_prefix="/api/rezervasyonlar")


@rezervasyon_bp.route("/", methods=["GET"])
@token_required
def liste_rezervasyonlar(current_user):
    """
    Tüm rezervasyonları listeler.
    NOT: Gerek yoksa bu endpoint'i tamamen kaldırabilirsin (güvenlik için).
    """
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Rezervasyonlar")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)


@rezervasyon_bp.route("/add", methods=["POST"])
@token_required
def rezervasyon_ekle(current_user):
    data = request.json or {}

    KullaniciID = current_user["KullaniciID"]
    AracID = data.get("AracID")
    AlisOfisID = data.get("AlisOfisID")
    TeslimOfisID = data.get("TeslimOfisID")
    AlisTarihi = data.get("AlisTarihi")
    TeslimTarihi = data.get("TeslimTarihi")

    # Eksik alan kontrolü
    if not all([AracID, AlisOfisID, TeslimOfisID, AlisTarihi, TeslimTarihi]):
        return jsonify({"error": "Tüm alanlar zorunlu"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # --- Tarih doğrulama ---
        t1 = datetime.datetime.strptime(AlisTarihi, "%Y-%m-%d")
        t2 = datetime.datetime.strptime(TeslimTarihi, "%Y-%m-%d")
        gun = (t2 - t1).days

        if gun <= 0:
            return jsonify({"error": "Teslim tarihi, alış tarihinden sonra olmalıdır"}), 400

        # Geçmiş tarih kontrolü
        bugun = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        if t1 < bugun:
            return jsonify({"error": "Alış tarihi bugünden önce olamaz"}), 400

        # --- Araç kontrolü ---
        cursor.execute("""
                       SELECT AracID, GunlukKiraUcreti, Durum, MevcutOfisID
                       FROM Araclar
                       WHERE AracID = %s
                       """, (AracID,))
        arac = cursor.fetchone()

        if not arac:
            return jsonify({"error": "Araç bulunamadı"}), 404

        # Araç bakımda mı kontrolü
        if arac["Durum"] == "Bakımda":
            return jsonify({"error": "Bu araç şu anda bakımda, rezervasyon yapılamaz"}), 400

        GunlukUcret = arac["GunlukKiraUcreti"]
        MevcutOfisID = arac["MevcutOfisID"]

        # --- Alış ofisi kontrolü ---
        cursor.execute("SELECT OfisID, OfisAdi FROM Ofisler WHERE OfisID = %s", (AlisOfisID,))
        alis_ofis = cursor.fetchone()
        if not alis_ofis:
            return jsonify({"error": "Alış ofisi bulunamadı"}), 404

        # --- Teslim ofisi kontrolü ---
        cursor.execute("SELECT OfisID, OfisAdi FROM Ofisler WHERE OfisID = %s", (TeslimOfisID,))
        teslim_ofis = cursor.fetchone()
        if not teslim_ofis:
            return jsonify({"error": "Teslim ofisi bulunamadı"}), 404

        # --- Aracın alış tarihinde alış ofisinde olup olmayacağını kontrol et ---
        # En son tamamlanacak rezervasyona bak (alış tarihinden önce biten)
        cursor.execute("""
                       SELECT TeslimOfisID, TeslimTarihi
                       FROM Rezervasyonlar
                       WHERE AracID = %s
                         AND Durum IN ('Onaylandı', 'Devam Ediyor')
                         AND TeslimTarihi <= %s
                       ORDER BY TeslimTarihi DESC LIMIT 1
                       """, (AracID, AlisTarihi))

        son_rezervasyon = cursor.fetchone()

        if son_rezervasyon:
            # Araç en son bu rezervasyonun teslim ofisinde olacak
            arac_olacagi_ofis = son_rezervasyon["TeslimOfisID"]
        else:
            # Araç şu anki ofisinde kalacak
            arac_olacagi_ofis = MevcutOfisID

        # Aracın alış ofisinde olup olmayacağını kontrol et
        if arac_olacagi_ofis != int(AlisOfisID):
            # Hangi ofiste olacağını bul
            cursor.execute("SELECT OfisAdi FROM Ofisler WHERE OfisID = %s", (arac_olacagi_ofis,))
            olacagi_ofis = cursor.fetchone()
            ofis_adi = olacagi_ofis["OfisAdi"] if olacagi_ofis else "Bilinmeyen ofis"

            return jsonify({
                "error": f"Bu araç seçilen alış tarihinde '{ofis_adi}' ofisinde olacak. Lütfen o ofisi seçin veya farklı bir tarih deneyin."
            }), 400

        # --- Tarih çakışması kontrolü ---
        # Aynı araç için aynı tarih aralığında aktif rezervasyon var mı?
        cursor.execute("""
                       SELECT COUNT(*) as catisma
                       FROM Rezervasyonlar
                       WHERE AracID = %s
                         AND Durum IN ('Onaylandı', 'Devam Ediyor', 'Beklemede')
                         AND (
                           -- Yeni rezervasyonun başlangıcı mevcut bir rezervasyonun içinde
                           (AlisTarihi <= %s AND TeslimTarihi > %s)
                               -- Yeni rezervasyonun bitişi mevcut bir rezervasyonun içinde
                               OR (AlisTarihi < %s AND TeslimTarihi >= %s)
                               -- Yeni rezervasyon mevcut bir rezervasyonu tamamen kapsıyor
                               OR (AlisTarihi >= %s AND TeslimTarihi <= %s)
                           )
                       """, (AracID, AlisTarihi, AlisTarihi, TeslimTarihi, TeslimTarihi, AlisTarihi, TeslimTarihi))

        result = cursor.fetchone()
        if result["catisma"] > 0:
            return jsonify({"error": "Bu araç seçilen tarihlerde başka bir rezervasyon için ayrılmış"}), 400

        # --- Toplam ücret hesapla ---
        ToplamUcret = gun * GunlukUcret

        # --- Rezervasyonu kaydet ---
        sql = """
              INSERT INTO Rezervasyonlar
              (KullaniciID, AracID, AlisOfisID, TeslimOfisID, AlisTarihi, TeslimTarihi, ToplamUcret, Durum)
              VALUES (%s, %s, %s, %s, %s, %s, %s, 'Onaylandı') \
              """

        cursor.execute(sql, (KullaniciID, AracID, AlisOfisID, TeslimOfisID, AlisTarihi, TeslimTarihi, ToplamUcret))
        conn.commit()

        return jsonify({
            "message": "Rezervasyon başarıyla oluşturuldu!",
            "RezervasyonID": cursor.lastrowid,
            "GunSayisi": gun,
            "ToplamUcret": ToplamUcret,
            "AlisOfisi": alis_ofis["OfisAdi"],
            "TeslimOfisi": teslim_ofis["OfisAdi"]
        })

    except ValueError as e:
        return jsonify({"error": "Geçersiz tarih formatı. YYYY-MM-DD formatında girin."}), 400
    except Exception as e:
        print("Rezervasyon ekleme hatası:", str(e))
        return jsonify({"error": "Beklenmeyen hata: " + str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@rezervasyon_bp.route("/my", methods=["GET"])
@token_required
def benim_rezervasyonlarim(current_user):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT r.RezervasyonID, \
                 a.Marka, \
                 a.Model, \
                 o1.OfisAdi AS AlisOfisi, \
                 o2.OfisAdi AS TeslimOfisi, \
                 r.AlisTarihi, \
                 r.TeslimTarihi, \
                 r.ToplamUcret, \
                 r.Durum
          FROM Rezervasyonlar r
                   JOIN Araclar a ON r.AracID = a.AracID
                   JOIN Ofisler o1 ON r.AlisOfisID = o1.OfisID
                   JOIN Ofisler o2 ON r.TeslimOfisID = o2.OfisID
          WHERE r.KullaniciID = %s
          ORDER BY r.AlisTarihi DESC \
          """

    cursor.execute(sql, (current_user["KullaniciID"],))
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify({
        "Kullanici": current_user["AdSoyad"],
        "RezervasyonSayisi": len(rows),
        "Rezervasyonlar": rows
    })


@rezervasyon_bp.route("/cancel/<int:rez_id>", methods=["PUT"])
@token_required
def kullanici_rezervasyon_iptal(current_user, rez_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
                   SELECT RezervasyonID, Durum
                   FROM Rezervasyonlar
                   WHERE RezervasyonID = %s
                     AND KullaniciID = %s
                   """, (rez_id, current_user["KullaniciID"]))

    rez = cursor.fetchone()

    if not rez:
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu rezervasyon size ait değil"}), 403

    if rez["Durum"] in ["Tamamlandı", "İptal Edildi"]:
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu rezervasyon zaten kapatılmış"}), 400

    # Devam Ediyor durumunda kullanıcı iptal edemez (araç müşteride)
    if rez["Durum"] == "Devam Ediyor":
        cursor.close()
        conn.close()
        return jsonify({
                           "error": "Araç teslim alındıktan sonra kullanıcı tarafından iptal edilemez. Lütfen ofis ile iletişime geçin."}), 400

    cursor.execute("""
                   UPDATE Rezervasyonlar
                   SET Durum = 'İptal Edildi'
                   WHERE RezervasyonID = %s
                   """, (rez_id,))

    # Araç durumunu güncelle (eğer Onaylandı durumundaysa)
    cursor.execute("""
                   UPDATE Araclar a
                       JOIN Rezervasyonlar r
                   ON a.AracID = r.AracID
                       SET a.Durum = 'Müsait'
                   WHERE r.RezervasyonID = %s AND a.Durum = 'Kirada'
                   """, (rez_id,))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({
        "message": "Rezervasyon başarıyla iptal edildi",
        "RezervasyonID": rez_id
    })