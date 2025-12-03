from flask import Blueprint, jsonify, request
from backend.db import get_connection
from backend.utils import token_required
import datetime

fatura_bp = Blueprint("fatura", __name__, url_prefix="/api/fatura")


# --- Fatura numarası otomatik üretici ---
def generate_fatura_no(cursor):
    cursor.execute("SELECT FaturaNo FROM Faturalar ORDER BY FaturaID DESC LIMIT 1")
    last = cursor.fetchone()

    # Hiç fatura yoksa F00001 ile başlat
    if not last:
        return "F00001"

    # FaturaNo: F00012 → 12
    last_no = int(last["FaturaNo"][1:])
    new_no = last_no + 1

    return f"F{new_no:05d}"


# --- Fatura oluşturma endpoint ---
@fatura_bp.route("/olustur/<int:rez_id>", methods=["POST"])
@token_required
def fatura_olustur(current_user, rez_id):
    data = request.json or {}

    # frontend ödeme yöntemi göndermediyse "Nakit" olarak kaydedilir
    OdemeYontemi = data.get("OdemeYontemi", "Nakit")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # --- Rezervasyon + araç + ofis + müşteri bilgilerini çek ---
        cursor.execute("""
            SELECT 
                r.RezervasyonID,
                r.AlisTarihi, r.TeslimTarihi, r.ToplamUcret,
                a.Marka, a.Model, a.Plaka,
                o1.OfisAdi AS AlisOfisi,
                o2.OfisAdi AS TeslimOfisi,
                k.Ad, k.Soyad, k.Eposta, k.Telefon
            FROM Rezervasyonlar r
            JOIN Araclar a ON r.AracID = a.AracID
            JOIN Ofisler o1 ON r.AlisOfisID = o1.OfisID
            JOIN Ofisler o2 ON r.TeslimOfisID = o2.OfisID
            JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
            WHERE r.RezervasyonID = %s AND r.KullaniciID = %s
        """, (rez_id, current_user["KullaniciID"]))

        rez = cursor.fetchone()

        if not rez:
            return jsonify({"error": "Rezervasyon bulunamadı"}), 404

        # --- Tutar ve KDV Hesabı ---
        Tutar = rez["ToplamUcret"]
        KDV = round(Tutar * 0.20, 2)  # %20 KDV
        Toplam = Tutar + KDV

        # --- Yeni bir FaturaNo üret ---
        FaturaNo = generate_fatura_no(cursor)

        # --- Fatura tablosuna kaydet ---
        cursor.execute("""
            INSERT INTO Faturalar (RezervasyonID, FaturaNo, FaturaTarihi, Tutar, KDV, OdemeYontemi)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            rez_id,
            FaturaNo,
            datetime.datetime.now().strftime("%Y-%m-%d"),
            Tutar,
            KDV,
            OdemeYontemi
        ))

        conn.commit()

        # --- Frontend’e dönecek tam fatura JSON’ı ---
        fatura_json = {
            "FaturaNo": FaturaNo,
            "FaturaTarihi": datetime.datetime.now().strftime("%Y-%m-%d"),
            "RezervasyonID": rez_id,
            "Tutar": Tutar,
            "KDV": KDV,
            "Toplam": Toplam,
            "OdemeYontemi": OdemeYontemi,

            "Musteri": {
                "Ad": rez["Ad"],
                "Soyad": rez["Soyad"],
                "Eposta": rez["Eposta"],
                "Telefon": rez["Telefon"]
            },

            "Arac": {
                "Marka": rez["Marka"],
                "Model": rez["Model"],
                "Plaka": rez["Plaka"]
            },

            "Rezervasyon": {
                "AlisOfisi": rez["AlisOfisi"],
                "TeslimOfisi": rez["TeslimOfisi"],
                "AlisTarihi": rez["AlisTarihi"],
                "TeslimTarihi": rez["TeslimTarihi"]
            }
        }

        return jsonify(fatura_json)

    except Exception as e:
        print("Fatura oluşturma hatası:", str(e))
        return jsonify({"error": "Sunucu hatası: " + str(e)}), 500

    finally:
        cursor.close()
        conn.close()
