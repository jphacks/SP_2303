import os

from app.types.client_response import (
    AnonymousPost,
    AnonymousPostImage,
    GoogleMapShop,
    SwipePost,
    User,
)


def equal_anonymous_post(a1: AnonymousPost, a2: AnonymousPost) -> None:
    assert a1["id"] == a2["id"]
    assert a1["userId"] == a2["userId"]
    assert a1["timelineId"] == a2["timelineId"]
    assert a1["googleMapShopId"] == a2["googleMapShopId"]
    assert a1["star"] == a2["star"]

    assert len(a1["imageList"]) == len(a2["imageList"])
    for image1, image2 in zip(a1["imageList"], a2["imageList"]):
        equal_anonymous_post_image(image1, image2)


def equal_anonymous_post_image(a1: AnonymousPostImage, a2: AnonymousPostImage) -> None:
    assert a1["id"] == a2["id"]
    assert a1["anonymousPostId"] == a2["anonymousPostId"]


def equal_google_map_shop(a1: GoogleMapShop, a2: GoogleMapShop) -> None:
    assert a1["name"] == a2["name"]
    assert a1["address"] == a2["address"]
    assert a1["googleMapShopId"] == a2["googleMapShopId"]
    assert a1["latitude"] == a2["latitude"]
    assert a1["longitude"] == a2["longitude"]


def equal_swipe_post(a1: SwipePost, a2: SwipePost) -> None:
    assert a1["star"] == a2["star"]
    equal_google_map_shop(a1["googleMapShop"], a2["googleMapShop"])


def equal_user(a1: User, a2: User) -> None:
    assert a1["name"] == a2["name"]
    assert a1["userId"] == a2["userId"]
    assert a1["iconKind"] == a2["iconKind"]


def should_exist_media_image(imagePath: str) -> None:
    # imagePathがルート始まりの場合、joinが上手くできないので一度分解して結合する
    pathList = ["tests"]
    pathList.extend(imagePath.split("/"))
    imageSystemPath = os.path.join(*pathList)
    assert os.path.exists(imageSystemPath)


def should_not_exist_media_image(imagePath: str) -> None:
    # imagePathがルート始まりの場合、joinが上手くできないので一度分解して結合する
    pathList = ["tests"]
    pathList.extend(imagePath.split("/"))
    imageSystemPath = os.path.join(*pathList)
    assert not os.path.exists(imageSystemPath)
