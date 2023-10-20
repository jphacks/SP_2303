import os

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

load_dotenv(verbose=True)  # .envの読み込み

# 接続先DBの設定
DATABASE_URL = os.environ.get("DATABASE_URL", "")

Engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=Engine)


def get_db() -> Session:
    return SessionLocal()
