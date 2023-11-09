from fastapi import APIRouter, Depends, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from app.crud import user as user_crud
from app.db import get_db
from app.dependency import get_current_user
from app.schema.user import User, UserCreate
from app.types.fireabase import UserInfo
from app.utils.logger import get_logger

router = APIRouter()

logger = get_logger()


# ユーザー情報を取得
@router.get("/api/user/me", status_code=status.HTTP_200_OK)
async def get_user(
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> User:
    logger.debug("request: GET /api/user/me")
    uid = cred["uid"]
    userModel = user_crud.get_user(db, uid)
    userSchema = User.from_model(userModel)
    return userSchema


# ユーザー作成
@router.post("/api/user", status_code=status.HTTP_201_CREATED)
async def create_user(
    body: UserCreate,
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: POST /api/user")
    uid = cred["uid"]
    # すでにユーザーが存在する場合はエラー
    user = user_crud.get_user(db, uid)
    if user is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, detail=f"User already exists"
        )
    return user_crud.create_user(
        db,
        uid,
        body.name,
        body.iconKind,
    )


# ユーザーidからユーザー情報を更新
@router.put("/api/user", status_code=status.HTTP_200_OK)
async def update_user(
    body: UserCreate,
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: PUT /api/user")
    uid = cred["uid"]
    # ユーザーが存在しない場合はエラー
    user = user_crud.get_user(db, uid)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"User not found"
        )
    return user_crud.update_user(db, uid, body.name, body.iconKind)


@router.delete("/api/user/withdraw", status_code=status.HTTP_204_NO_CONTENT)
async def delete_anonymous_post_and_image(
    db: Session = Depends(get_db),
    cred: UserInfo = Depends(get_current_user),
) -> None:
    logger.debug("request: DELETE /api/user/withdraw")
    uid = cred["uid"]


    user_crud.delete_anonymous_post_image_by_uid(
        db,
        uid,
    )
    user_crud.delete_anonymous_post_by_uid(
        db,
        uid,
    )
    user_crud.delete_user(
        db,
        uid,
    )
