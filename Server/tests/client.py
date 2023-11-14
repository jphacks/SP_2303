import json

from fastapi.testclient import TestClient
from httpx import Response

from tests.data import (
    POST1_CREATE,
    POST1_DELETE,
    POST1_FILES_CREATE,
    USER1_CREATE,
    USER1_UPDATE,
)


class CustomTestClient:
    client: TestClient

    def __init__(self, client: TestClient) -> None:
        self.client = client

    def get_anonymouspost(self) -> Response:
        response = self.client.get("/api/anonymous-post")
        return response

    def post_anonymouspost_id1(self) -> Response:
        response = self.client.post(
            "/api/anonymous-post",
            data=POST1_CREATE,
            files=POST1_FILES_CREATE,
        )
        return response

    def delete_anonymouspost_id1(self) -> Response:
        response = self.client.request(
            method="DELETE",
            url="/api/anonymous-post",
            content=json.dumps(POST1_DELETE),
        )
        return response

    def get_swipe_anonymouspost(self, param: dict[str, int]) -> Response:
        response = self.client.get("/api/swipe/anonymous-post", params=param)
        return response

    def get_user_me(self) -> Response:
        response = self.client.get(
            "/api/user/me",
        )
        return response

    def post_user_id1(self) -> Response:
        response = self.client.post(
            "/api/user",
            json=USER1_CREATE,
        )
        return response

    def put_user_id1(self) -> Response:
        response = self.client.put(
            "/api/user",
            json=USER1_UPDATE,
        )
        return response

    def delete_user_withdraw(self) -> Response:
        response = self.client.delete(
            "/api/user/withdraw",
        )
        return response

    def get_by_url(self, url: str) -> Response:
        response = self.client.get(url)
        return response
