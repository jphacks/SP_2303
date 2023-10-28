import os

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.settings import DATABASE_URL, DEBUG

Engine = create_engine(DATABASE_URL, echo=DEBUG)
SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=Engine)


def get_db() -> Session:
    return SessionLocal()
