from flask import Blueprint, jsonify, request
from backend.db import get_connection
from backend.utils import ofis_token_required

ofis_bp = Blueprint("ofis", __name__, url_prefix="/api/ofis")


# -------------------------
#   OFİS KENDİ BİLGİSİ
# -------------------------
@ofis_bp.route("/me", methods=["GET"])
@ofis_token_required
def ofis_me(current_ofis):
    return jsonify(current_ofis)


# -------------------------
#   OFİS DASHBOARD İSTATİSTİKLERİ
# -------------------------
@ofis_bp.route("/dashboard", methods=["GET"])
@ofis_token_required
def ofis_dashboard(current_ofis):
    """Ofis dashboard istatistikleri"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    stats = {
        "OfisAdi": current_ofis["OfisAdi"],
        "OfisID": current_ofis["OfisID"]
    }

    # Toplam araç sayısı (bu ofiste)
    cursor.execute("""
                   SELECT COUNT(*) as toplam
                   FROM Araclar
                   WHERE MevcutOfisID = %s
                   """, (current_ofis["OfisID"],))
    stats["toplamArac"] = cursor.fetchone()["toplam"]

    # Müsait araç sayısı
    cursor.execute("""
                   SELECT COUNT(*) as musait
                   FROM Araclar
                   WHERE MevcutOfisID = %s
                     AND Durum = 'Müsait'
                   """, (current_ofis["OfisID"],))
    stats["musaitArac"] = cursor.fetchone()["musait"]

    # Kiradaki araç sayısı
    cursor.execute("""
                   SELECT COUNT(*) as kirada
                   FROM Araclar
                   WHERE MevcutOfisID = %s
                     AND Durum = 'Kirada'
                   """, (current_ofis["OfisID"],))
    stats["kiradaArac"] = cursor.fetchone()["kirada"]

    # Bakımdaki araç sayısı
    cursor.execute("""
                   SELECT COUNT(*) as bakim
                   FROM Araclar
                   WHERE MevcutOfisID = %s
                     AND Durum = 'Bakımda'
                   """, (current_ofis["OfisID"],))
    stats["bakimdaArac"] = cursor.fetchone()["bakim"]

    # Bekleyen rezervasyonlar (Alış ofisi olarak)
    cursor.execute("""
                   SELECT COUNT(*) as bekleyen
                   FROM Rezervasyonlar
                   WHERE AlisOfisID = %s
                     AND Durum = 'Beklemede'
                   """, (current_ofis["OfisID"],))
    stats["bekleyenRezervasyon"] = cursor.fetchone()["bekleyen"]

    # Onaylanan rezervasyonlar
    cursor.execute("""
                   SELECT COUNT(*) as onaylanan
                   FROM Rezervasyonlar
                   WHERE AlisOfisID = %s
                     AND Durum = 'Onaylandı'
                   """, (current_ofis["OfisID"],))
    stats["onaylananRezervasyon"] = cursor.fetchone()["onaylanan"]

    # Bu ay toplam gelir (Alış ofisi olarak)
    cursor.execute("""
                   SELECT SUM(ToplamUcret) as gelir
                   FROM Rezervasyonlar
                   WHERE AlisOfisID = %s
                       AND Durum IN ('Onaylandı', 'Tamamlandı')
                       AND MONTH (
                       AlisTarihi) = MONTH (CURDATE())
                     AND YEAR (AlisTarihi) = YEAR (CURDATE())
                   """, (current_ofis["OfisID"],))
    result = cursor.fetchone()
    stats["buAyGelir"] = result["gelir"] or 0

    cursor.close()
    conn.close()

    return jsonify(stats)


# -------------------------
#   OFİSİN MEVCUT ARAÇLARI
# -------------------------
@ofis_bp.route("/araclar", methods=["GET"])
@ofis_token_required
def ofis_araclari(current_ofis):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT AracID, \
                 Plaka, \
                 Marka, \
                 Model, \
                 Yil, \
                 VitesTuru, \
                 YakitTipi, \
                 GunlukKiraUcreti, \
                 Durum
          FROM Araclar
          WHERE MevcutOfisID = %s
          ORDER BY Marka, Model, Yil DESC \
          """
    cursor.execute(sql, (current_ofis["OfisID"],))
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify({
        "Ofis": current_ofis["OfisAdi"],
        "AracSayisi": len(rows),
        "Araclar": rows
    })


# -------------------------
#   YENİ ARAÇ EKLE
# -------------------------
@ofis_bp.route("/araclar/ekle", methods=["POST"])
@ofis_token_required
def yeni_arac_ekle(current_ofis):
    """Ofis, kendi lokasyonuna yeni araç ekler"""
    data = request.json or {}

    required = ["Plaka", "Marka", "Model", "Yil", "YakitTipi", "VitesTuru", "GunlukKiraUcreti"]
    for field in required:
        if not data.get(field):
            return jsonify({"error": f"{field} zorunludur"}), 400

    conn = get_connection()
    cursor = conn.cursor()

    # Plaka kontrolü
    cursor.execute("SELECT AracID FROM Araclar WHERE Plaka = %s", (data["Plaka"],))
    if cursor.fetchone():
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu plaka zaten kayıtlı"}), 400

    cursor.execute("""
                   INSERT INTO Araclar
                   (Plaka, Marka, Model, Yil, YakitTipi, VitesTuru, GunlukKiraUcreti, MevcutOfisID, Durum)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'Müsait')
                   """, (
                       data["Plaka"], data["Marka"], data["Model"], data["Yil"],
                       data["YakitTipi"], data["VitesTuru"], data["GunlukKiraUcreti"],
                       current_ofis["OfisID"]
                   ))

    conn.commit()
    arac_id = cursor.lastrowid

    cursor.close()
    conn.close()

    return jsonify({"message": "Araç başarıyla eklendi", "AracID": arac_id}), 201


# -------------------------
#   ARAÇ DURUMU GÜNCELLE
# -------------------------
@ofis_bp.route("/araclar/<int:arac_id>/durum", methods=["PUT"])
@ofis_token_required
def arac_durum_guncelle(current_ofis, arac_id):
    """Araç durumunu güncelle (Müsait/Bakımda/Kirada)"""
    data = request.json or {}
    yeni_durum = data.get("Durum")

    if yeni_durum not in ["Müsait", "Bakımda", "Kirada"]:
        return jsonify({"error": "Geçersiz durum"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Araç bu ofise ait mi?
    cursor.execute("""
                   SELECT AracID
                   FROM Araclar
                   WHERE AracID = %s
                     AND MevcutOfisID = %s
                   """, (arac_id, current_ofis["OfisID"]))

    if not cursor.fetchone():
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu araç size ait değil"}), 403

    cursor.execute("""
                   UPDATE Araclar
                   SET Durum = %s
                   WHERE AracID = %s
                   """, (yeni_durum, arac_id))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({"message": "Araç durumu güncellendi", "YeniDurum": yeni_durum})


# -------------------------
#   ARAÇ BİLGİSİ GÜNCELLE
# -------------------------
@ofis_bp.route("/araclar/<int:arac_id>", methods=["PUT"])
@ofis_token_required
def arac_guncelle(current_ofis, arac_id):
    """Araç bilgilerini güncelle"""
    data = request.json or {}

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Araç kontrolü
    cursor.execute("""
                   SELECT AracID
                   FROM Araclar
                   WHERE AracID = %s
                     AND MevcutOfisID = %s
                   """, (arac_id, current_ofis["OfisID"]))

    if not cursor.fetchone():
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu araç size ait değil"}), 403

    updates = []
    values = []

    if "GunlukKiraUcreti" in data:
        updates.append("GunlukKiraUcreti = %s")
        values.append(data["GunlukKiraUcreti"])

    if "YakitTipi" in data:
        updates.append("YakitTipi = %s")
        values.append(data["YakitTipi"])

    if "VitesTuru" in data:
        updates.append("VitesTuru = %s")
        values.append(data["VitesTuru"])

    if not updates:
        cursor.close()
        conn.close()
        return jsonify({"error": "Güncellenecek alan yok"}), 400

    values.append(arac_id)
    sql = f"UPDATE Araclar SET {', '.join(updates)} WHERE AracID = %s"

    cursor.execute(sql, values)
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({"message": "Araç bilgileri güncellendi"})


# -------------------------
#  ALIŞ OFİSİ OLDUĞU REZERVASYONLAR
# -------------------------
@ofis_bp.route("/rezervasyonlar/alis", methods=["GET"])
@ofis_token_required
def ofis_alis_rezervasyonlari(current_ofis):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT r.RezervasyonID, \
                 k.Ad, \
                 k.Soyad, \
                 k.Telefon, \
                 a.Marka, \
                 a.Model, \
                 a.Plaka, \
                 r.AlisTarihi, \
                 r.TeslimTarihi, \
                 r.ToplamUcret, \
                 r.Durum, \
                 o2.OfisAdi as TeslimOfisi
          FROM Rezervasyonlar r
                   JOIN Araclar a ON r.AracID = a.AracID
                   JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
                   JOIN Ofisler o2 ON r.TeslimOfisID = o2.OfisID
          WHERE r.AlisOfisID = %s
          ORDER BY r.AlisTarihi DESC \
          """
    cursor.execute(sql, (current_ofis["OfisID"],))
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify({
        "Ofis": current_ofis["OfisAdi"],
        "Tip": "Alış Ofisi Olduğu Rezervasyonlar",
        "RezervasyonSayisi": len(rows),
        "Rezervasyonlar": rows
    })


# -------------------------
#  TESLİM OFİSİ OLDUĞU REZERVASYONLAR
# -------------------------
@ofis_bp.route("/rezervasyonlar/teslim", methods=["GET"])
@ofis_token_required
def ofis_teslim_rezervasyonlari(current_ofis):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT r.RezervasyonID, \
                 k.Ad, \
                 k.Soyad, \
                 k.Telefon, \
                 a.Marka, \
                 a.Model, \
                 a.Plaka, \
                 r.AlisTarihi, \
                 r.TeslimTarihi, \
                 r.ToplamUcret, \
                 r.Durum, \
                 o1.OfisAdi as AlisOfisi
          FROM Rezervasyonlar r
                   JOIN Araclar a ON r.AracID = a.AracID
                   JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
                   JOIN Ofisler o1 ON r.AlisOfisID = o1.OfisID
          WHERE r.TeslimOfisID = %s
          ORDER BY r.AlisTarihi DESC \
          """
    cursor.execute(sql, (current_ofis["OfisID"],))
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify({
        "Ofis": current_ofis["OfisAdi"],
        "Tip": "Teslim Ofisi Olduğu Rezervasyonlar",
        "RezervasyonSayisi": len(rows),
        "Rezervasyonlar": rows
    })


# -------------------------
#  REZERVASYON DURUMU GÜNCELLEME (ONAY/İPTAL/TESLİM)
#  Bu fonksiyonu mevcut ofis.py dosyanızdaki aynı isimli fonksiyon ile DEĞİŞTİRİN
# -------------------------
@ofis_bp.route("/rezervasyonlar/<int:rez_id>/durum", methods=["PUT"])
@ofis_token_required
def rezervasyon_durum_guncelle(current_ofis, rez_id):
    data = request.json or {}
    yeni_durum = data.get("Durum")

    # "Devam Ediyor" durumunu da ekledik
    izinli_durumlar = ["Onaylandı", "İptal Edildi", "Tamamlandı", "Devam Ediyor"]
    if yeni_durum not in izinli_durumlar:
        return jsonify({"error": "Geçersiz durum"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
                   SELECT RezervasyonID, AracID, AlisOfisID, TeslimOfisID, Durum, AlisTarihi, TeslimTarihi
                   FROM Rezervasyonlar
                   WHERE RezervasyonID = %s
                   """, (rez_id,))
    rez = cursor.fetchone()

    if not rez:
        cursor.close()
        conn.close()
        return jsonify({"error": "Rezervasyon bulunamadı"}), 404

    # Ofis yetkisi kontrolü
    if rez["AlisOfisID"] != current_ofis["OfisID"] and rez["TeslimOfisID"] != current_ofis["OfisID"]:
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu rezervasyonu değiştirme yetkiniz yok"}), 403

    # İş mantığı kontrolleri
    mevcut_durum = rez["Durum"]
    alis_ofisi_mi = rez["AlisOfisID"] == current_ofis["OfisID"]
    teslim_ofisi_mi = rez["TeslimOfisID"] == current_ofis["OfisID"]

    # Alış ofisi sadece: Onaylandı -> Devam Ediyor (araç teslim) veya İptal yapabilir
    if alis_ofisi_mi and not teslim_ofisi_mi:
        if yeni_durum == "Devam Ediyor" and mevcut_durum != "Onaylandı":
            cursor.close()
            conn.close()
            return jsonify(
                {"error": "Araç teslimi sadece 'Onaylandı' durumundaki rezervasyonlar için yapılabilir"}), 400

        if yeni_durum == "İptal Edildi" and mevcut_durum not in ["Onaylandı", "Beklemede"]:
            cursor.close()
            conn.close()
            return jsonify({"error": "Bu rezervasyon iptal edilemez"}), 400

        if yeni_durum == "Tamamlandı":
            cursor.close()
            conn.close()
            return jsonify({"error": "Alış ofisi rezervasyonu tamamlayamaz, sadece teslim ofisi tamamlayabilir"}), 403

    # Teslim ofisi: Devam Ediyor -> Tamamlandı yapabilir, Onaylandı veya Devam Ediyor -> İptal yapabilir
    if teslim_ofisi_mi and not alis_ofisi_mi:
        if yeni_durum == "Tamamlandı" and mevcut_durum != "Devam Ediyor":
            cursor.close()
            conn.close()
            return jsonify({
                               "error": "Rezervasyon tamamlama sadece 'Devam Ediyor' durumundaki rezervasyonlar için yapılabilir"}), 400

        if yeni_durum == "İptal Edildi" and mevcut_durum not in ["Onaylandı", "Devam Ediyor"]:
            cursor.close()
            conn.close()
            return jsonify({"error": "Bu rezervasyon iptal edilemez"}), 400

        if yeni_durum == "Devam Ediyor":
            cursor.close()
            conn.close()
            return jsonify({"error": "Teslim ofisi araç teslimi yapamaz, sadece alış ofisi yapabilir"}), 403

    # Eğer aynı ofis hem alış hem teslim ofisiyse (tek ofisli kiralama)
    if alis_ofisi_mi and teslim_ofisi_mi:
        # Tüm geçişlere izin ver ama mantıklı sırada
        if yeni_durum == "Devam Ediyor" and mevcut_durum != "Onaylandı":
            cursor.close()
            conn.close()
            return jsonify(
                {"error": "Araç teslimi sadece 'Onaylandı' durumundaki rezervasyonlar için yapılabilir"}), 400

        if yeni_durum == "Tamamlandı" and mevcut_durum != "Devam Ediyor":
            cursor.close()
            conn.close()
            return jsonify({
                               "error": "Rezervasyon tamamlama sadece 'Devam Ediyor' durumundaki rezervasyonlar için yapılabilir"}), 400

    # Onaylanıyorsa tarih çakışması kontrolü
    if yeni_durum == "Onaylandı":
        cursor.execute("""
                       SELECT COUNT(*) as catisma
                       FROM Rezervasyonlar
                       WHERE AracID = %s
                         AND RezervasyonID != %s
                         AND Durum IN ('Onaylandı'
                           , 'Beklemede'
                           , 'Devam Ediyor')
                         AND (
                           (AlisTarihi <= %s
                         AND TeslimTarihi >= %s)
                          OR (AlisTarihi >= %s
                         AND AlisTarihi <= %s)
                           )
                       """, (rez["AracID"], rez_id, rez["TeslimTarihi"], rez["AlisTarihi"], rez["AlisTarihi"],
                             rez["TeslimTarihi"]))

        result = cursor.fetchone()
        if result["catisma"] > 0:
            cursor.close()
            conn.close()
            return jsonify({"error": "Bu araç için seçilen tarihlerde başka bir rezervasyon var!"}), 400

    # Durum güncelle
    cursor.execute("""
                   UPDATE Rezervasyonlar
                   SET Durum = %s
                   WHERE RezervasyonID = %s
                   """, (yeni_durum, rez_id))

    # Araç durumu güncellemeleri
    if yeni_durum == "Tamamlandı":
        # Araç teslim ofisine taşınır ve müsait olur
        cursor.execute("""
                       UPDATE Araclar
                       SET MevcutOfisID = %s,
                           Durum        = 'Müsait'
                       WHERE AracID = %s
                       """, (rez["TeslimOfisID"], rez["AracID"]))

    elif yeni_durum == "Onaylandı":
        # Araç kirada olarak işaretlenir (henüz teslim edilmedi ama rezerve)
        cursor.execute("""
                       UPDATE Araclar
                       SET Durum = 'Kirada'
                       WHERE AracID = %s
                       """, (rez["AracID"],))

    elif yeni_durum == "Devam Ediyor":
        # Araç müşteride, hala kirada
        cursor.execute("""
                       UPDATE Araclar
                       SET Durum = 'Kirada'
                       WHERE AracID = %s
                       """, (rez["AracID"],))

    elif yeni_durum == "İptal Edildi":
        # Araç müsait olur
        cursor.execute("""
                       UPDATE Araclar
                       SET Durum = 'Müsait'
                       WHERE AracID = %s
                       """, (rez["AracID"],))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({
        "message": "Rezervasyon durumu güncellendi",
        "YeniDurum": yeni_durum
    })

# -------------------------
#   OFİS LİSTESİ (PUBLIC)
# -------------------------
@ofis_bp.route("/list", methods=["GET"])
def ofis_listesi():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT OfisID, OfisAdi, Sehir, Adres, Telefon FROM Ofisler")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)