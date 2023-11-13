import os

from dotenv import load_dotenv

## settings.pyが読み込まれる前に、.envとTESTINGの設定をする ##
load_dotenv(verbose=True)
os.environ["TESTING"] = "1"  # テスト中であることを示す環境変数を設定
os.environ["DEBUG"] = "0"  # デバッグログを表示しないためにDEBUGモードをオフに

import shutil
from typing import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy_utils import create_database, database_exists, drop_database

from app.db import Base, get_db
from app.dependency import get_current_user
from app.models import *
from app.settings import SYSTEM_MEDIA_PATH
from app.types.fireabase import UserInfo
from main import app
from tests.client import CustomTestClient

TEST_DATABASE_URL = os.environ.get("TEST_DATABASE_URL", "")
if TEST_DATABASE_URL == "":
    raise Exception("Please set TEST_DATABASE_URL as an environment variable")


@pytest.fixture(scope="session", autouse=True)
def delete_test_media_dir() -> Generator[None, None, None]:
    yield
    shutil.rmtree(SYSTEM_MEDIA_PATH)


@pytest.fixture(scope="session", autouse=True)
def init_detabase() -> Generator[None, None, None]:
    # データベースの初期化
    if database_exists(TEST_DATABASE_URL):
        drop_database(TEST_DATABASE_URL)
    create_database(TEST_DATABASE_URL)

    yield

    drop_database(TEST_DATABASE_URL)


@pytest.fixture(scope="function")
def client() -> Generator[CustomTestClient, None, None]:
    client = CustomTestClient(TestClient(app))
    engine = create_engine(TEST_DATABASE_URL, echo=False)
    sessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)

    # テーブル作り直し
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)

    def get_test_db() -> Generator[Session, None, None]:
        with sessionLocal() as session:
            yield session

    app.dependency_overrides[get_db] = get_test_db
    app.dependency_overrides[get_current_user] = get_test_user1

    yield client

    engine.dispose()


def get_test_user1() -> UserInfo:
    return {
        "name": "test_user1",
        "picture": "http://example.com",
        "iss": "http://example.com",
        "aud": "gohan-map",
        "auth_time": 0,
        "user_id": "test_user1_id",
        "sub": "test_user1_id",
        "iat": 0,
        "exp": 0,
        "firebase": {},
        "uid": "test_user1_id",
    }


def get_test_user2() -> UserInfo:
    return {
        "name": "test_user2",
        "picture": "http://example.com",
        "iss": "http://example.com",
        "aud": "gohan-map",
        "auth_time": 0,
        "user_id": "test_user2_id",
        "sub": "test_user2_id",
        "iat": 0,
        "exp": 0,
        "firebase": {},
        "uid": "test_user2_id",
    }
