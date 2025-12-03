from flask import Flask
from flask_cors import CORS

from backend.routes.araclar import arac_bp
from backend.routes.kullanicilar import kullanici_bp
from backend.routes.rezervasyonlar import rezervasyon_bp
from backend.routes.auth import auth_bp
from backend.routes.ofis import ofis_bp
from backend.routes.fatura import fatura_bp


def create_app():
    app = Flask(__name__)

    # CORS ayarlarını genişlet
    CORS(app, resources={
        r"/api/*": {
            "origins": ["http://localhost:3000"],
            "methods": ["GET", "POST", "PUT", "DELETE"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })

    app.config["SECRET_KEY"] = "supersecretkey"

    app.register_blueprint(auth_bp)
    app.register_blueprint(arac_bp)
    app.register_blueprint(kullanici_bp)
    app.register_blueprint(rezervasyon_bp)
    app.register_blueprint(ofis_bp)
    app.register_blueprint(fatura_bp)

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)
