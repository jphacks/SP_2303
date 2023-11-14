from typing import Any, TypedDict


# JSONの型と同じ名前なのでスネークケースになる
class UserInfo(TypedDict):
    name: str
    picture: str
    iss: str
    aud: str
    auth_time: int
    user_id: str
    sub: str
    iat: int
    exp: int
    firebase: Any
    uid: str
