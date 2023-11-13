from fastapi import APIRouter, Depends, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session
from starlette.responses import Response

import app.schema.anonymous_post as post_schema
from app.crud import anonymous_post
from app.db import get_db
from app.dependency import get_current_user
from app.types.fireabase import UserInfo
from app.utils.logger import get_logger

router = APIRouter()

logger = get_logger()


@router.get("/api/anonymous-post", response_model=list[post_schema.AnonymousPost])
async def list_anonymous_post(
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> list[post_schema.AnonymousPost]:
    logger.debug("request: GET /api/anonymous-post")
    uid = cred["uid"]

    postModelList = anonymous_post.fetch_anonymous_post_by_uid(db, uid)
    postSchemaList: list[post_schema.AnonymousPost] = list(
        map(lambda x: post_schema.AnonymousPost.from_model(x), postModelList)
    )

    return postSchemaList


@router.post(
    "/api/anonymous-post", status_code=status.HTTP_201_CREATED, response_class=Response
)
async def create_anonymous_post(
    timelineId: int = Form(),
    googleMapShopId: str = Form(),
    longitude: float = Form(),
    latitude: float = Form(),
    star: float = Form(),
    name: str = Form(),
    address: str = Form(),
    imageList: list[UploadFile] = Form(min_length=1),
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: POST /api/anonymous-post")
    uid = cred["uid"]

    # GoogleMapShopの追加・更新
    shop = anonymous_post.update_google_map_shop_by_shopId(
        db, googleMapShopId, longitude, latitude, name, address
    )
    # uidとtimelineIdから匿名投稿を取得
    posted_content = anonymous_post.fetch_anonymous_post_by_uid_timelineId(
        db, uid, timelineId
    )
    # return posted_content
    #  すでに投稿がある場合は更新
    if posted_content is not None:
        post = anonymous_post.update_anonymous_post(
            db,
            uid,
            timelineId,
            googleMapShopId,
            star,
        )
        # imageの削除
        anonymous_post.delete_anonymous_post_image_by_uid_timelineId(
            db, uid, timelineId
        )
    else:
        # 匿名投稿の追加
        post = anonymous_post.create_anonymous_post(
            db,
            uid,
            timelineId,
            googleMapShopId,
            star,
        )
    # 匿名投稿の画像の追加
    await anonymous_post.create_anonymous_post_image(db, post.id, imageList)


@router.delete("/api/anonymous-post", status_code=status.HTTP_204_NO_CONTENT)
async def delete_anonymous_post(
    body: post_schema.AnonymousPostDelete,
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: DELETE /api/anonymous-post")
    uid = cred["uid"]
    post = anonymous_post.fetch_anonymous_post_by_uid_timelineId(
        db, uid, body.timelineId
    )
    if post is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Post not found"
        )

    anonymous_post.delete_anonymous_post_by_uid_timelineId(db, uid, body.timelineId)
