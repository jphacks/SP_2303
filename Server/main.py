import firebase_admin
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.router import anonymous_post, swipe
from app.settings import FIREBASE_CONFIG

## 初期化 ##
firebase_admin.initialize_app(firebase_admin.credentials.Certificate(FIREBASE_CONFIG))


app = FastAPI()

# ルーティングの設定
app.include_router(anonymous_post.router)
app.include_router(swipe.router)

# 静的ファイルのマウント
app.mount("/media", StaticFiles(directory="app/media"), name="media")
