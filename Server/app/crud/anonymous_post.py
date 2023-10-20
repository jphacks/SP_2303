from datetime import datetime

from fastapi import UploadFile
from sqlalchemy.orm import Session

from app.models.anonymous_post import AnonymousPost
from app.models.anonymous_post_image import AnonymousPostImage
from app.models.google_map_shop import GoogleMapShop


def fetch_anonymous_post_by_uid(db: Session, uid: str) -> list[AnonymousPost]:
    posts = db.query(AnonymousPost).filter(AnonymousPost.userId == uid).all()
    return posts


def update_google_map_shop_by_shopId(
    db: Session, googleMapShopId: str, longitude: float, latitude: float
) -> GoogleMapShop | None:
    shop = (
        db.query(GoogleMapShop)
        .filter(GoogleMapShop.googleMapShopId == googleMapShopId)
        .first()
    )
    if shop is None:
        shop = GoogleMapShop(
            googleMapShopId=googleMapShopId,
            longitude=longitude,
            latitude=latitude,
            createdAt=datetime.now(),
            updatedAt=datetime.now(),
        )
        db.add(shop)
    else:
        shop.longitude = longitude
        shop.latitude = latitude
        shop.updatedAt = datetime.now()
    db.commit()
    db.refresh(shop)
    return shop


def create_anonymous_post(
    db: Session,
    uid: str,
    timelineId: int,
    googleMapShopId: str,
    star: float,
) -> AnonymousPost:
    post = AnonymousPost(
        userId=uid,
        timelineId=timelineId,
        googleMapShopId=googleMapShopId,
        star=star,
        createdAt=datetime.now(),
        updatedAt=datetime.now(),
    )
    db.add(post)
    db.commit()
    db.refresh(post)
    return post


def create_anonymous_post_image(
    db: Session,
    anonymousPostId: int,
    filenames: list[str],
) -> AnonymousPost:
    for filename in filenames:
        post = AnonymousPostImage(
            anonymousPostId=anonymousPostId,
            fileName=filename,
            createdAt=datetime.now(),
            updatedAt=datetime.now(),
        )
        db.add(post)
    db.commit()


def fetch_google_map_shop_by_shopId(
    db: Session, googleMapShopId: str
) -> GoogleMapShop | None:
    shop = (
        db.query(GoogleMapShop)
        .filter(GoogleMapShop.googleMapShopId == googleMapShopId)
        .first()
    )
    return shop


def fetch_anonymous_post_by_uid_timelineId(
    db: Session, uid: str, timelineId: int
) -> AnonymousPost | None:
    post = (
        db.query(AnonymousPost)
        .filter(AnonymousPost.userId == uid, AnonymousPost.timelineId == timelineId)
        .first()
    )
    return post


def delete_anonymous_post_by_uid_timelineId(
    db: Session, uid: str, timelineId: int
) -> None:
    # TODO: 画像ファイルの削除を同時にする
    db.query(AnonymousPost).filter(
        AnonymousPost.userId == uid, AnonymousPost.timelineId == timelineId
    ).delete()
    db.commit()
