from typing import TypedDict


class AnonymousPostImage(TypedDict):
    id: int
    anonymousPostId: int
    imageURL: str
    createdAt: str
    updatedAt: str


class AnonymousPost(TypedDict):
    id: int
    userId: str
    timelineId: int
    googleMapShopId: str
    star: float
    imageList: list[AnonymousPostImage]
    createdAt: str
    updatedAt: str
