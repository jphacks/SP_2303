import os
from typing import Any, Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy_utils import create_database, database_exists, drop_database

from app.db import Base, get_db
from app.dependency import get_current_user
from app.models import *
from app.types.fireabase import UserInfo
from main import app

TEST_DATABASE_URL = os.environ.get("TEST_DATABASE_URL", "")
if TEST_DATABASE_URL == "":
    raise Exception("Please set TEST_DATABASE_URL as an environment variable")


@pytest.fixture(scope="session", autouse=True)
def init_detabase() -> None:
    # データベースの初期化
    if database_exists(TEST_DATABASE_URL):
        drop_database(TEST_DATABASE_URL)
    create_database(TEST_DATABASE_URL)

    yield

    drop_database(TEST_DATABASE_URL)


@pytest.fixture(scope="function")
def client() -> TestClient:
    client = TestClient(app)
    engine = create_engine(TEST_DATABASE_URL, echo=True)
    sessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)

    # テーブル作り直し
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)

    def get_test_db() -> Generator[Session, None, None]:
        with sessionLocal() as session:
            yield session

    def get_test_user() -> UserInfo:
        return {
            "name": "test_usesr",
            "picture": "http://example.com",
            "iss": "http://example.com",
            "aud": "gohan-map-e09bd",
            "auth_time": 0,
            "user_id": "test_user_id",
            "sub": "test_user_id",
            "iat": 0,
            "exp": 0,
            "firebase": {},
            "uid": "test_user_id",
        }

    app.dependency_overrides[get_db] = get_test_db
    app.dependency_overrides[get_current_user] = get_test_user

    yield client

    engine.dispose()
