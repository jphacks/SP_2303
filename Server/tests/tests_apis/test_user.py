from urllib.parse import urlparse

from fastapi import status

from app.types.client_response import AnonymousPost, User
from tests.client import CustomTestClient
from tests.data import EXPECTED_UPDATED_USER1, EXPECTED_USER1
from tests.utils import equal_user, should_not_exist_media_image


def test_error_read_no_user(client: CustomTestClient) -> None:
    response = client.get_user_me()
    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_create_user1_and_read(client: CustomTestClient) -> None:
    # user1のデータを作成
    response = client.post_user_id1()
    assert response.status_code == status.HTTP_201_CREATED
    assert response.content == b""

    # 作成したuser1のデータを取得
    response = client.get_user_me()
    assert response.status_code == status.HTTP_200_OK
    res_user: User = response.json()
    equal_user(res_user, EXPECTED_USER1)


def test_error_create_existed_user(client: CustomTestClient) -> None:
    # user1のデータを作成
    response = client.post_user_id1()

    # user1のデータを再度作成
    response = client.post_user_id1()
    assert response.status_code == status.HTTP_409_CONFLICT


def test_update_user1(client: CustomTestClient) -> None:
    # user1のデータを作成
    response = client.post_user_id1()

    # user1を更新
    response = client.put_user_id1()
    assert response.status_code == status.HTTP_200_OK
    assert response.content == b""

    # 更新したuser1のデータを取得
    response = client.get_user_me()
    assert response.status_code == status.HTTP_200_OK
    res_user: User = response.json()
    equal_user(res_user, EXPECTED_UPDATED_USER1)


def test_error_update_no_user(client: CustomTestClient) -> None:
    response = client.put_user_id1()
    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_withdraw_no_user(client: CustomTestClient) -> None:
    # user1のデータが存在しない状態で、退会処理をしてもエラーを出さない
    response = client.delete_user_withdraw()
    assert response.status_code == status.HTTP_204_NO_CONTENT


def test_withdraw_user1(client: CustomTestClient) -> None:
    # user1のデータを作成
    response = client.post_user_id1()

    # 退会処理
    response = client.delete_user_withdraw()
    assert response.status_code == status.HTTP_204_NO_CONTENT
    assert response.content == b""

    # user1が削除されたことをチェック
    response = client.get_user_me()
    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_withdraw_user1_with_post(client: CustomTestClient) -> None:
    # user1のデータを作成
    response = client.post_user_id1()
    # 匿名投稿を画像付きで作成
    response = client.post_anonymouspost_id1()

    # 画像URLの取得
    response = client.get_anonymouspost()
    imageURL: str = response.json()[0]["imageList"][0]["imageURL"]

    # 退会処理
    response = client.delete_user_withdraw()
    assert response.status_code == status.HTTP_204_NO_CONTENT
    assert response.content == b""

    # user1が削除されたことをチェック
    response = client.get_user_me()
    assert response.status_code == status.HTTP_404_NOT_FOUND

    # 削除されていることを確認
    response = client.get_anonymouspost()
    assert response.status_code == status.HTTP_200_OK
    res: list[AnonymousPost] = response.json()
    assert isinstance(res, list)
    assert len(res) == 0

    o = urlparse(imageURL)
    should_not_exist_media_image(o.path)
