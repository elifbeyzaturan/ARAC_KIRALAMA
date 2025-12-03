from flask import Blueprint, request, jsonify, current_app
import jwt
import datetime
import hashlib
from backend.db import get_connection

auth_bp = Blueprint("auth", __name__, url_prefix="/api/auth")


# -------------------------
#   KULLANICI KAYIT
# -------------------------
@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.json or {}

    Ad = data.get("Ad")
    Soyad = data.get("Soyad")
    Eposta = data.get("Eposta")
    Sifre = data.get("Sifre")
    Telefon = data.get("Telefon")
    EhliyetNumarasi = data.get("EhliyetNumarasi")

    if not Ad or not Soyad or not Eposta or not Sifre:
        return jsonify({"error": "Ad, Soyad, Eposta ve Şifre zorunludur"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM Kullanicilar WHERE Eposta=%s", (Eposta,))
    existing = cursor.fetchone()
    if existing:
        cursor.close()
        conn.close()
        return jsonify({"error": "Bu e-posta zaten kayıtlı"}), 400

    # TODO: ileride burada da hash kullanılabilir
    cursor.execute(
        """
        INSERT INTO Kullanicilar (Ad, Soyad, Eposta, SifreHash, Telefon, EhliyetNumarasi)
        VALUES (%s, %s, %s, %s, %s, %s)
        """,
        (Ad, Soyad, Eposta, Sifre, Telefon, EhliyetNumarasi)
    )
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({"message": "Kayıt başarılı"}), 201


# -------------------------
#   KULLANICI GİRİŞ
# -------------------------
@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json or {}

    Eposta = data.get("Eposta")
    Sifre = data.get("Sifre")

    if not Eposta or not Sifre:
        return jsonify({"error": "E-posta ve şifre gereklidir"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT KullaniciID, Ad, Soyad, SifreHash
        FROM Kullanicilar
        WHERE Eposta=%s
        """,
        (Eposta,)
    )
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if not user:
        return jsonify({"error": "Kullanıcı bulunamadı"}), 404

    # TODO: ileride hash doğrulaması yapılabilir
    if user["SifreHash"] != Sifre:
        return jsonify({"error": "Hatalı şifre"}), 401

    payload = {
        "KullaniciID": user["KullaniciID"],
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=2)
    }

    token = jwt.encode(
        payload,
        current_app.config["SECRET_KEY"],
        algorithm="HS256"
    )

    return jsonify({
        "message": "Giriş başarılı",
        "AdSoyad": f"{user['Ad']} {user['Soyad']}",
        "token": token
    })


# -------------------------
#       OFİS GİRİŞİ
# -------------------------
@auth_bp.route("/ofis-login", methods=["POST"])
def ofis_login():
    data = request.json or {}

    Eposta = data.get("Eposta")
    Sifre = data.get("Sifre")

    if not Eposta or not Sifre:
        return jsonify({"error": "Eposta ve şifre gerekli"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT OfisID, OfisAdi, SifreHash FROM Ofisler WHERE Eposta=%s",
        (Eposta,)
    )
    ofis = cursor.fetchone()
    cursor.close()
    conn.close()

    if not ofis:
        return jsonify({"error": "Ofis bulunamadı"}), 404

    # Gelen şifreyi SHA-256 ile hash’le
    sifre_hash = hashlib.sha256(Sifre.encode("utf-8")).hexdigest()

    if sifre_hash != ofis["SifreHash"]:
        return jsonify({"error": "Şifre hatalı"}), 401

    payload = {
        "OfisID": ofis["OfisID"],
        "rol": "ofis",
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=4)
    }

    token = jwt.encode(
        payload,
        current_app.config["SECRET_KEY"],
        algorithm="HS256"
    )

    return jsonify({
        "message": "Ofis girişi başarılı",
        "OfisAdi": ofis["OfisAdi"],
        "token": token
    })
