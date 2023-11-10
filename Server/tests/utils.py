from app.types.client_response import AnonymousPost, AnonymousPostImage


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
