from sqlalchemy.orm import Session

from app.models.anonymous_post import AnonymousPost


def fetch_anonymous_post_by_uid(db: Session, uid: str) -> list[AnonymousPost]:
    posts = db.query(AnonymousPost).filter(AnonymousPost.userId == uid).all()
    return posts


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
