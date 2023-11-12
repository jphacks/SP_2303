import json
from urllib.parse import urlparse

from fastapi import status
from fastapi.testclient import TestClient

from app.types.client_response import AnonymousPost
from tests.data import EXPECTED_POST1, POST1_CREATE, POST1_DELETE, POST1_FILES_CREATE
from tests.utils import equal_anonymous_post, exist_media_image


def test_read_no_content(client: TestClient) -> None:
    response = client.get("/api/anonymous-post")
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0


def test_create_post1(client: TestClient) -> None:
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )
    assert response.status_code == status.HTTP_201_CREATED
    res: None = response.json()
    assert res == None


def test_read_post1(client: TestClient) -> None:
    # post1の作成
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )

    # post1の取得
    response = client.get("/api/anonymous-post")
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()

    # 想定する値との比較
    assert isinstance(res, list)
    assert len(res) == 1
    equal_anonymous_post(res[0], EXPECTED_POST1)

    # 画像が保存されているか確認
    imageURL = res[0]["imageList"][0]["imageURL"]
    o = urlparse(imageURL)
    exist_media_image(o.path)
    response = client.get(imageURL)
    assert response.status_code == status.HTTP_200_OK

    with open("tests/assets/sample_gohan1.png", "rb") as f:
        assert response.content == f.read()


def test_delete_no_content(client: TestClient) -> None:
    response = client.request(
        method="DELETE",
        url="/api/anonymous-post",
        content=json.dumps(POST1_DELETE),
    )
    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_delete_post1(client: TestClient) -> None:
    # post1の作成
    response = client.post(
        "/api/anonymous-post",
        data=POST1_CREATE,
        files=POST1_FILES_CREATE,
    )

    # post1の削除
    response = client.request(
        method="DELETE",
        url="/api/anonymous-post",
        content=json.dumps(POST1_DELETE),
    )
    assert response.status_code == status.HTTP_204_NO_CONTENT

    # 削除されていることを確認
    response = client.get("/api/anonymous-post")
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0
