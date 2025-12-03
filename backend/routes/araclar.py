from flask import Blueprint, jsonify, request
from backend.db import get_connection

arac_bp = Blueprint("araclar", __name__, url_prefix="/api/araclar")


@arac_bp.route("/", methods=["GET"])
def liste_araclar():
    """Tüm araçları listeler (ofis bilgisi ile birlikte)"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT a.AracID, \
                 a.Plaka, \
                 a.Marka, \
                 a.Model, \
                 a.Yil, \
                 a.YakitTipi, \
                 a.VitesTuru, \
                 a.GunlukKiraUcreti, \
                 a.MevcutOfisID, \
                 a.Durum, \
                 o.OfisAdi AS MevcutOfisAdi, \
                 o.Sehir   AS MevcutOfisSehir
          FROM Araclar a
                   LEFT JOIN Ofisler o ON a.MevcutOfisID = o.OfisID
          ORDER BY a.Marka, a.Model \
          """

    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)


@arac_bp.route("/<int:arac_id>", methods=["GET"])
def arac_detay(arac_id):
    """Tek bir aracın detaylı bilgisini getirir"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT a.AracID, \
                 a.Plaka, \
                 a.Marka, \
                 a.Model, \
                 a.Yil, \
                 a.YakitTipi, \
                 a.VitesTuru, \
                 a.GunlukKiraUcreti, \
                 a.MevcutOfisID, \
                 a.Durum, \
                 o.OfisAdi AS MevcutOfisAdi, \
                 o.Sehir   AS MevcutOfisSehir, \
                 o.Adres   AS MevcutOfisAdres, \
                 o.Telefon AS MevcutOfisTelefon
          FROM Araclar a
                   LEFT JOIN Ofisler o ON a.MevcutOfisID = o.OfisID
          WHERE a.AracID = %s \
          """

    cursor.execute(sql, (arac_id,))
    arac = cursor.fetchone()
    cursor.close()
    conn.close()

    if not arac:
        return jsonify({"error": "Araç bulunamadı"}), 404

    return jsonify(arac)


@arac_bp.route("/markalar", methods=["GET"])
def marka_listesi():
    """Benzersiz marka listesi"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT DISTINCT Marka FROM Araclar ORDER BY Marka")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify([r["Marka"] for r in rows])


@arac_bp.route("/modeller", methods=["GET"])
def model_listesi():
    """Benzersiz model listesi"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT DISTINCT Model FROM Araclar ORDER BY Model")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify([r["Model"] for r in rows])


@arac_bp.route("/filtreli", methods=["POST"])
def filtreli_araclar():
    """Filtrelenmiş araç listesi - tarih ve ofis bazlı müsaitlik kontrolü ile"""
    data = request.json or {}

    AlisOfisID = data.get("AlisOfisID")
    TeslimOfisID = data.get("TeslimOfisID")
    AlisTarihi = data.get("AlisTarihi")
    TeslimTarihi = data.get("TeslimTarihi")
    Marka = data.get("Marka")
    Model = data.get("Model")
    Yakit = data.get("YakitTipi")
    Vites = data.get("VitesTuru")
    MinFiyat = data.get("MinFiyat")
    MaxFiyat = data.get("MaxFiyat")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # ----------------------------------------------------
    # SQL FİLTRE İNŞA EDİLİYOR
    # ----------------------------------------------------
    sql = """
          SELECT a.AracID, \
                 a.Plaka, \
                 a.Marka, \
                 a.Model, \
                 a.Yil, \
                 a.YakitTipi, \
                 a.VitesTuru, \
                 a.GunlukKiraUcreti, \
                 a.MevcutOfisID, \
                 a.Durum, \
                 o.OfisAdi AS MevcutOfisAdi, \
                 o.Sehir   AS MevcutOfisSehir
          FROM Araclar a
                   LEFT JOIN Ofisler o ON a.MevcutOfisID = o.OfisID
          WHERE a.Durum IN ('Müsait') \
          """

    params = []

    if Marka:
        sql += " AND a.Marka = %s"
        params.append(Marka)

    if Model:
        sql += " AND a.Model = %s"
        params.append(Model)

    if Yakit:
        sql += " AND a.YakitTipi = %s"
        params.append(Yakit)

    if Vites:
        sql += " AND a.VitesTuru = %s"
        params.append(Vites)

    if MinFiyat:
        sql += " AND a.GunlukKiraUcreti >= %s"
        params.append(MinFiyat)

    if MaxFiyat:
        sql += " AND a.GunlukKiraUcreti <= %s"
        params.append(MaxFiyat)

    # ----------------------------------------------------
    # Müsaitlik kontrolü – seçilen tarihler arasında rezervasyon var mı?
    # ----------------------------------------------------
    if AlisTarihi and TeslimTarihi:
        sql += """
            AND a.AracID NOT IN (
                SELECT r.AracID FROM Rezervasyonlar r
                WHERE r.Durum IN ('Onaylandı', 'Devam Ediyor', 'Beklemede')
                AND (
                    (r.AlisTarihi <= %s AND r.TeslimTarihi > %s)
                    OR (r.AlisTarihi < %s AND r.TeslimTarihi >= %s)
                    OR (r.AlisTarihi >= %s AND r.TeslimTarihi <= %s)
                )
            )
        """
        params += [AlisTarihi, AlisTarihi, TeslimTarihi, TeslimTarihi, AlisTarihi, TeslimTarihi]

    # ----------------------------------------------------
    # Alış ofisine göre filtre
    # ----------------------------------------------------
    if AlisOfisID:
        sql += " AND a.MevcutOfisID = %s"
        params.append(AlisOfisID)

    sql += " ORDER BY a.GunlukKiraUcreti ASC"

    cursor.execute(sql, params)
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(rows)


@arac_bp.route("/musait", methods=["GET"])
def musait_araclar():
    """Sadece müsait araçları listeler"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT a.AracID, \
                 a.Plaka, \
                 a.Marka, \
                 a.Model, \
                 a.Yil, \
                 a.YakitTipi, \
                 a.VitesTuru, \
                 a.GunlukKiraUcreti, \
                 a.MevcutOfisID, \
                 a.Durum, \
                 o.OfisAdi AS MevcutOfisAdi, \
                 o.Sehir   AS MevcutOfisSehir
          FROM Araclar a
                   LEFT JOIN Ofisler o ON a.MevcutOfisID = o.OfisID
          WHERE a.Durum = 'Müsait'
          ORDER BY a.Marka, a.Model \
          """

    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)


@arac_bp.route("/ofis/<int:ofis_id>", methods=["GET"])
def ofis_araclari(ofis_id):
    """Belirli bir ofisteki araçları listeler"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
          SELECT a.AracID, \
                 a.Plaka, \
                 a.Marka, \
                 a.Model, \
                 a.Yil, \
                 a.YakitTipi, \
                 a.VitesTuru, \
                 a.GunlukKiraUcreti, \
                 a.MevcutOfisID, \
                 a.Durum, \
                 o.OfisAdi AS MevcutOfisAdi, \
                 o.Sehir   AS MevcutOfisSehir
          FROM Araclar a
                   LEFT JOIN Ofisler o ON a.MevcutOfisID = o.OfisID
          WHERE a.MevcutOfisID = %s
          ORDER BY a.Durum, a.Marka, a.Model \
          """

    cursor.execute(sql, (ofis_id,))
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)