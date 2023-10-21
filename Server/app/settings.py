import os

from dotenv import load_dotenv

load_dotenv(verbose=True)  # NOTE: 本番環境ではコンテナ起動時に環境変数を登録する為、.envからの読み込みはない

DEBUG = bool(int(os.environ["DEBUG"]))

ORIGIN = os.environ["BACKEND_ORIGIN"]

PUBLIC_MEDIA_PATH = "/media/"
PUBLIC_MEDIA_IMAGE_PATH = os.path.join(PUBLIC_MEDIA_PATH, "images/")
PUBLIC_MEDIA_IMAGE_ANONYMOUS_POST_PATH = os.path.join(
    PUBLIC_MEDIA_IMAGE_PATH, "anonymous-post/"
)

SYETEM_MEDIA_PATH = "./app/media/images/anonymous-post"

# 接続先DBの設定
DATABASE_URL = os.environ.get("DATABASE_URL", "")

# Firebase
FIREBASE_CONFIG = {
    "type": os.environ.get("FIREBASE_TYPE", ""),
    "project_id": os.environ.get("FIREBASE_PROJECT_ID", ""),
    "private_key_id": os.environ.get("FIREBASE_PRIVATE_KEY_ID", ""),
    "private_key": os.environ.get("FIREBASE_PRIVATE_KEY", "").replace(r'\n', '\n'),
    "client_email": os.environ.get("FIREABSE_CLIENT_EMAIL", ""),
    "client_id": os.environ.get("FIREBASE_CLIENT_ID", ""),
    "auth_uri": os.environ.get("FIREBASE_AUTH_URI", ""),
    "token_uri": os.environ.get("FIREBASE_TOKEN_URI", ""),
    "auth_provider_x509_cert_url": os.environ.get(
        "FIREBASE_AUTH_PROVIDER_X509_CERT_URL", ""
    ),
    "client_x509_cert_url": os.environ.get("FIREBASE_CLIENT_X509_CERT_URL", ""),
    "universe_domain": os.environ.get("FIREBASE_UNIVERSE_DOMAIN", ""),
}
