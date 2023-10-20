import os

from dotenv import load_dotenv

load_dotenv(verbose=True)  # .envの読み込み

DEBUG = bool(int(os.environ["DEBUG"]))

ORIGIN = os.environ["BACKEND_ORIGIN"]

PUBLIC_MEDIA_PATH = "/media/"
PUBLIC_MEDIA_IMAGE_PATH = os.path.join(PUBLIC_MEDIA_PATH, "images/")
PUBLIC_MEDIA_IMAGE_ANONYMOUS_POST_PATH = os.path.join(
    PUBLIC_MEDIA_IMAGE_PATH, "anonymous-post/"
)

# 接続先DBの設定
DATABASE_URL = os.environ.get("DATABASE_URL", "")
