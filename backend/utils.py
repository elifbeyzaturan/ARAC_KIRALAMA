import jwt
from functools import wraps
from flask import request, jsonify, current_app
from backend.db import get_connection


# --------------------------
#  MÜŞTERİ TOKEN KONTROLÜ
# --------------------------
def token_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        token = None

        # Authorization: Bearer <token>
        auth_header = request.headers.get("Authorization")
        if auth_header:
            parts = auth_header.split()
            if len(parts) == 2 and parts[0].lower() == "bearer":
                token = parts[1]

        if not token:
            return jsonify({"error": "Token gerekli"}), 401

        try:
            payload = jwt.decode(
                token,
                current_app.config["SECRET_KEY"],
                algorithms=["HS256"]
            )

            current_user_id = payload["KullaniciID"]

            conn = get_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT Ad, Soyad FROM Kullanicilar WHERE KullaniciID = %s",
                (current_user_id,)
            )
            user = cursor.fetchone()
            cursor.close()
            conn.close()

            current_user = {
                "KullaniciID": current_user_id,
                "AdSoyad": f"{user['Ad']} {user['Soyad']}" if user else "Bilinmiyor"
            }

        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token süresi dolmuş"}), 401
        except Exception as e:
            print("USER TOKEN ERROR:", e)
            return jsonify({"error": "Token geçersiz"}), 401

        return f(current_user, *args, **kwargs)

    return wrapper


# --------------------------
#     OFİS TOKEN KONTROLÜ
# --------------------------
def ofis_token_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        token = None

        auth_header = request.headers.get("Authorization")
        if auth_header:
            parts = auth_header.split()
            if len(parts) == 2 and parts[0].lower() == "bearer":
                token = parts[1]

        if not token:
            return jsonify({"error": "Token gerekli"}), 401

        try:
            payload = jwt.decode(
                token,
                current_app.config["SECRET_KEY"],
                algorithms=["HS256"]
            )

            # bu token gerçekten OFİS için mi?
            if payload.get("rol") != "ofis":
                return jsonify({"error": "Bu işlem için ofis girişi gerekli"}), 403

            ofis_id = payload["OfisID"]

            conn = get_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT OfisID, OfisAdi, Sehir FROM Ofisler WHERE OfisID = %s",
                (ofis_id,)
            )
            ofis = cursor.fetchone()
            cursor.close()
            conn.close()

            if not ofis:
                return jsonify({"error": "Ofis bulunamadı"}), 404

            current_ofis = {
                "OfisID": ofis["OfisID"],
                "OfisAdi": ofis["OfisAdi"],
                "Sehir": ofis["Sehir"]
            }

        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token süresi dolmuş"}), 401
        except Exception as e:
            print("OFIS TOKEN ERROR:", e)
            return jsonify({"error": "Token geçersiz"}), 401

        return f(current_ofis, *args, **kwargs)

    return wrapper
