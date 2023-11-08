import os
import uuid

from fastapi import UploadFile, status
from sqlalchemy.orm import Session
from starlette.exceptions import HTTPException

from app.models.anonymous_post import AnonymousPost
from app.models.anonymous_post_image import AnonymousPostImage
from app.settings import SYSTEM_MEDIA_IMAGE_ANONYMOUS_POST_PATH
from app.utils.logger import get_logger

logger = get_logger()


def fetch_anonymous_post_by_uid(db: Session, uid: str) -> list[AnonymousPost]:
    posts = db.query(AnonymousPost).filter(AnonymousPost.userId == uid).all()
    return posts


def delete_anonymous_post_by_uid(db: Session, uid: str) -> None:
    post = db.query(AnonymousPost).filter(AnonymousPost.userId == uid).first()
    if post is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"Post not found"
        )

    db.query(AnonymousPost).filter(AnonymousPost.userId == uid).delete()
    db.commit()


def delete_anonymous_post_image_by_uid(db: Session, uid: str) -> None:
    # 該当の投稿を取得
    posts = db.query(AnonymousPost).filter(AnonymousPost.userId == uid).all()
    if posts is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"Post not found"
        )
    # ディレクトリが存在しない場合、作成する
    if not os.path.exists(SYSTEM_MEDIA_IMAGE_ANONYMOUS_POST_PATH):
        os.makedirs(SYSTEM_MEDIA_IMAGE_ANONYMOUS_POST_PATH)

    for post in posts:
        imageList = post.anonymousPostImages
        # ファイルを削除
        for image in imageList:
            file_path = os.path.join(
                SYSTEM_MEDIA_IMAGE_ANONYMOUS_POST_PATH, image.fileName
            )
            if os.path.exists(file_path):
                os.remove(file_path)

        # imageの削除
        db.query(AnonymousPostImage).filter(
            AnonymousPostImage.anonymousPostId == post.id
        ).delete()
        db.commit()
