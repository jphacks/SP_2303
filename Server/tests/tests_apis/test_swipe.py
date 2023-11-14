from urllib.parse import urlparse

from fastapi import status

from app.dependency import get_current_user
from app.types.client_response import SwipePost
from main import app
from tests.client import CustomTestClient
from tests.conftest import get_test_user2
from tests.data import (
    EXPECTED_SWIPE_POST1,
    SWIPE_QUERY_POST1_HIT,
    SWIPE_QUERY_POST1_NOHIT,
)
from tests.utils import equal_swipe_post, should_exist_media_image


def test_post1_hit(client: CustomTestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post_anonymouspost_id1()

    # user2でスワイプUIを実行
    app.dependency_overrides[get_current_user] = get_test_user2
    response = client.get_swipe_anonymouspost(SWIPE_QUERY_POST1_HIT)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 1
    equal_swipe_post(res[0], EXPECTED_SWIPE_POST1)

    # 画像の読み込みテスト
    imageURL = res[0]["imageURL"]
    o = urlparse(imageURL)
    should_exist_media_image(o.path)
    response = client.get_by_url(imageURL)
    assert response.status_code == status.HTTP_200_OK

    with open("tests/assets/sample_gohan1.png", "rb") as f:
        assert response.content == f.read()


def test_post1_no_hit(client: CustomTestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post_anonymouspost_id1()

    # user2でスワイプUIを実行
    app.dependency_overrides[get_current_user] = get_test_user2
    response = client.get_swipe_anonymouspost(SWIPE_QUERY_POST1_NOHIT)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0


def test_same_user_no_hit(client: CustomTestClient) -> None:
    # user1で匿名投稿を作成
    response = client.post_anonymouspost_id1()

    # user1でスワイプUIを実行
    response = client.get_swipe_anonymouspost(SWIPE_QUERY_POST1_HIT)
    assert response.status_code == status.HTTP_200_OK
    res: list[SwipePost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0
