import os

import firebase_admin
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.router import anonymous_post, swipe, user
from app.settings import FIREBASE_CONFIG, SYSTEM_MEDIA_PATH

## 初期化 ##
firebase_admin.initialize_app(firebase_admin.credentials.Certificate(FIREBASE_CONFIG))


app = FastAPI()

# ルーティングの設定
app.include_router(anonymous_post.router)
app.include_router(swipe.router)
app.include_router(user.router)

# 静的ファイルのマウント
if not os.path.exists(SYSTEM_MEDIA_PATH):
    os.makedirs(SYSTEM_MEDIA_PATH)
app.mount("/media", StaticFiles(directory="app/media"), name="media")
