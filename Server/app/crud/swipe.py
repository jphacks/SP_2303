from sqlalchemy.orm import Session
from sqlalchemy.sql import func

from app.models.anonymous_post import AnonymousPost
from app.models.google_map_shop import GoogleMapShop
from app.schema.swipe import SwipeAnonymousPostRequest


def search_anonymous_post_for_swipe(
    db: Session, uid: str, q: SwipeAnonymousPostRequest
) -> list[AnonymousPost]:
    """
    スワイプ用の匿名投稿を検索する

    [アルゴリズム概要]
    - ログインユーザー以外の投稿を取得
    - 指定クエリの範囲内にある投稿を取得
    """

    earthRadius = 6378
    x1 = func.radians(GoogleMapShop.longitude)
    y1 = func.radians(GoogleMapShop.latitude)
    x2 = func.radians(q.longitude)
    y2 = func.radians(q.latitude)
    dx = func.radians(func.abs(x1 - x2))
    dist = earthRadius * func.acos(
        func.sin(y1) * func.sin(y2) + func.cos(y1) * func.cos(y2) * func.cos(dx)
    )

    posts = (
        db.query(AnonymousPost)
        .join(
            GoogleMapShop,
            AnonymousPost.googleMapShopId == GoogleMapShop.googleMapShopId,
        )
        .filter(AnonymousPost.userId != uid)
        .filter(dist <= q.radius)
        .all()
    )
    return posts
