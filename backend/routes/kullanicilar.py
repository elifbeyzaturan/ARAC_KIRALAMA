from flask import Blueprint, jsonify
from backend.db import get_connection
from backend.utils import token_required

kullanici_bp = Blueprint("kullanicilar", __name__, url_prefix="/api/kullanicilar")


@kullanici_bp.route("/", methods=["GET"])
@token_required
def liste_kullanicilar(current_user):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            KullaniciID,
            Ad,
            Soyad,
            Eposta,
            Telefon,
            EhliyetNumarasi
        FROM Kullanicilar
    """)
    rows = cursor.fetchall()

    cursor.close()
    conn.close()
    return jsonify(rows)


@kullanici_bp.route("/me", methods=["GET"])
@token_required
def kullanici_bilgisi(current_user):
    """Giriş yapmış kullanıcının bilgilerini döndürür"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
                   SELECT KullaniciID,
                          Ad,
                          Soyad,
                          Eposta,
                          Telefon,
                          EhliyetNumarasi
                   FROM Kullanicilar
                   WHERE KullaniciID = %s
                   """, (current_user["KullaniciID"],))

    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if not user:
        return jsonify({"error": "Kullanıcı bulunamadı"}), 404

    return jsonify(user)
