from urllib.parse import urlparse

from fastapi import status
from fastapi.testclient import TestClient

from app.dependency import get_current_user
from app.types.client_response import SwipePost
from main import app
from tests.conftest import get_test_user2
from tests.data import (
    EXPECTED_SWIPE_POST1,
    POST1_CREATE,
    POST1_FILES_CREATE,
    SWIPE_QUERY1,
    SWIPE_QUERY2,
)
from tests.utils import equal_swipe_post, exist_media_image


def test_post1_hit(client: TestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )

    # user2でスワイプUIを実行
    app.dependency_overrides[get_current_user] = get_test_user2
    response = client.get("/api/swipe/anonymous-post", params=SWIPE_QUERY1)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 1
    equal_swipe_post(res[0], EXPECTED_SWIPE_POST1)

    # 画像の読み込みテスト
    imageURL = res[0]["imageURL"]
    o = urlparse(imageURL)
    exist_media_image(o.path)
    response = client.get(imageURL)
    assert response.status_code == status.HTTP_200_OK

    with open("tests/assets/sample_gohan1.png", "rb") as f:
        assert response.content == f.read()


def test_post1_no_hit(client: TestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )

    # user2でスワイプUIを実行
    app.dependency_overrides[get_current_user] = get_test_user2
    response = client.get("/api/swipe/anonymous-post", params=SWIPE_QUERY2)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0


def test_same_user_no_hit(client: TestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )

    # user1でスワイプUIを実行
    response = client.get("/api/swipe/anonymous-post", params=SWIPE_QUERY2)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0
