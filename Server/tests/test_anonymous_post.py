import json
from io import BufferedReader

from fastapi import status
from fastapi.testclient import TestClient

from app.types.client_response import AnonymousPost
from tests.utils import equal_anonymous_post, equal_anonymous_post_image

post1Create: dict[str, str] = {
    "timelineId": "1",
    "googleMapShopId": "google_id",
    "longitude": "140",
    "latitude": "40",
    "star": "3.0",
    "name": "匿名の店",
    "address": "北海道札幌市中央区",
}
post1FileCreate: dict[str, BufferedReader] = {
    "imageList": open("tests/assets/sample_gohan1.png", "rb")
}

expectedPost1: AnonymousPost = {
    "id": 1,
    "userId": "test_user_id",
    "timelineId": 1,
    "googleMapShopId": "google_id",
    "star": 3.0,
    "imageList": [
        {
            "id": 1,
            "anonymousPostId": 1,
            "imageURL": "",  # don't compare
            "createdAt": "",  # don't compare
            "updatedAt": "",  # don't compare
        }
    ],
    "createdAt": "",  # don't compare
    "updatedAt": "",  # don't compare
}


def test_read_no_content(client: TestClient) -> None:
    response = client.get("/api/anonymous-post")
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0


def test_create(client: TestClient) -> None:
    response = client.post(
        "/api/anonymous-post",
        data=post1Create,
        files=post1FileCreate,
    )
    assert response.status_code == status.HTTP_201_CREATED
    res: None = response.json()
    assert res == None


def test_read_post(client: TestClient) -> None:
    test_create(client)

    response = client.get("/api/anonymous-post")
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 1

    equal_anonymous_post(res[0], expectedPost1)


def test_delete_no_content(client: TestClient) -> None:
    data = {"timelineId": 1}
    response = client.request(
        method="DELETE",
        url="/api/anonymous-post",
        content=json.dumps(data),
    )
    assert response.status_code == status.HTTP_404_NOT_FOUND
