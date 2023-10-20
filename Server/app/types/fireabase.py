from typing import TypedDict


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
    email: str
    email_verified: bool
    uid: str
