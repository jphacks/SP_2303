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


class GoogleMapShop(TypedDict):
    googleMapShopId: str
    latitude: float
    longitude: float
    name: str
    address: str


class SwipePost(TypedDict):
    imageURL: str
    star: float
    googleMapShop: GoogleMapShop


class User(TypedDict):
    userId: str
    name: str
    iconKind: int
    createdAt: str
    updatedAt: str
