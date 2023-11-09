from fastapi import APIRouter, Depends, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from app.crud import user
from app.db import get_db
from app.dependency import get_current_user
from app.types.fireabase import UserInfo
from app.utils.logger import get_logger

router = APIRouter()

logger = get_logger()


@router.delete("/api/user/withdraw", status_code=status.HTTP_204_NO_CONTENT)
async def delete_anonymous_post_and_image(
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: DELETE /api/user/withdraw")
    uid = cred["uid"]

    user.delete_anonymous_post_image_by_uid(
        db,
        uid,
    )
    user.delete_anonymous_post_by_uid(
        db,
        uid,
    )
