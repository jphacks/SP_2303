from urllib.parse import urlparse

from fastapi import status

from app.types.client_response import AnonymousPost
from tests.client import CustomTestClient
from tests.data import EXPECTED_POST1
from tests.utils import (
    equal_anonymous_post,
    should_exist_media_image,
    should_not_exist_media_image,
)


def test_read_no_content(client: CustomTestClient) -> None:
    response = client.get_anonymouspost()
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0


def test_create_post1(client: CustomTestClient) -> None:
    response = client.post_anonymouspost_id1()
    assert response.status_code == status.HTTP_201_CREATED
    assert response.content == b""


def test_create_and_read_post1(client: CustomTestClient) -> None:
    # post1の作成
    response = client.post_anonymouspost_id1()

    # post1の取得
    response = client.get_anonymouspost()
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()

    # 想定する値との比較
    assert isinstance(res, list)
    assert len(res) == 1
    equal_anonymous_post(res[0], EXPECTED_POST1)

    # 画像が保存されているか確認
    imageURL = res[0]["imageList"][0]["imageURL"]
    o = urlparse(imageURL)
    should_exist_media_image(o.path)
    response = client.get_by_url(imageURL)
    assert response.status_code == status.HTTP_200_OK

    with open("tests/assets/sample_gohan1.png", "rb") as f:
        assert response.content == f.read()


def test_error_delete_no_content(client: CustomTestClient) -> None:
    response = client.delete_anonymouspost_id1()
    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_create_and_delete_post1(client: CustomTestClient) -> None:
    # post1の作成
    response = client.post_anonymouspost_id1()

    # 画像URLの取得
    response = client.get_anonymouspost()
    imageURL: str = response.json()[0]["imageList"][0]["imageURL"]

    # post1の削除
    response = client.delete_anonymouspost_id1()
    assert response.status_code == status.HTTP_204_NO_CONTENT
    assert response.content == b""

    # 削除されていることを確認
    response = client.get_anonymouspost()
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0

    o = urlparse(imageURL)
    should_not_exist_media_image(o.path)
