from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

import app.schema.swipe as swipe_schema
from app.crud.swipe import search_anonymous_post_for_swipe
from app.db import get_db
from app.dependency import get_current_user
from app.types.fireabase import UserInfo
from app.utils.logger import get_logger

router = APIRouter()

logger = get_logger()


@router.get(
    "/api/swipe/anonymous-post", response_model=list[swipe_schema.SwipeAnonymousPost]
)
async def list_anonymous_post(
    q: swipe_schema.SwipeAnonymousPostRequest = Depends(),
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> list[swipe_schema.SwipeAnonymousPost]:
    logger.debug("request: GET /api/swipe/anonymous-post")
    uid = cred["uid"]
    postModels = search_anonymous_post_for_swipe(db, uid, q)
    swipePostSchema = swipe_schema.SwipeAnonymousPost.from_model_list(postModels)

    return swipePostSchema
