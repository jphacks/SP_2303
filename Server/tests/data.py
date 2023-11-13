from io import BufferedReader

from app.types.client_response import AnonymousPost, SwipePost, User

# データ
POST1_CREATE: dict[str, str] = {
    "timelineId": "1",
    "googleMapShopId": "google_id",
    "longitude": "140",
    "latitude": "40",
    "star": "3.0",
    "name": "匿名の店",
    "address": "北海道札幌市中央区",
}
POST1_FILES_CREATE: list[tuple[str, BufferedReader]] = [
    ("imageList", open("tests/assets/sample_gohan1.png", "rb"))
]
POST1_DELETE: dict[str, int] = {"timelineId": 1}

# (40, 140) <-> (40, 141)の距離は、約85km
SWIPE_QUERY_POST1_HIT = {"latitude": 40, "longitude": 141, "radius": 86}
SWIPE_QUERY_POST1_NOHIT = {
    "latitude": 40,
    "longitude": 141,
    "radius": 84,
}

USER1_CREATE = {"name": "test_user1", "iconKind": 1}
USER1_UPDATE = {"name": "test_user1_updated", "iconKind": 2}

# 想定値
EXPECTED_POST1: AnonymousPost = {
    "id": 1,
    "userId": "test_user1_id",
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

EXPECTED_SWIPE_POST1: SwipePost = {
    "star": 3.0,
    "googleMapShop": {
        "googleMapShopId": "google_id",
        "latitude": 40,
        "longitude": 140,
        "name": "匿名の店",
        "address": "北海道札幌市中央区",
    },
    "imageURL": "",  # don't compare
}

EXPECTED_USER1: User = {
    "name": "test_user1",
    "userId": "test_user1_id",
    "iconKind": 1,
    "createdAt": "",  # don't compare
    "updatedAt": "",  # don't compare
}

EXPECTED_UPDATED_USER1: User = {
    "name": "test_user1_updated",
    "userId": "test_user1_id",
    "iconKind": 2,
    "createdAt": "",  # don't compare
    "updatedAt": "",  # don't compare
}
