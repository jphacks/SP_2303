from datetime import datetime
from typing import TypeVar

from fastapi import Form, UploadFile
from pydantic import BaseModel, Field

from app.models.user import User as UserModel


class UserCreate(BaseModel):
    name: str
    icon_kind: int


Self = TypeVar("Self", bound="User")


class User(BaseModel):
    userId: str
    name: str
    icon_kind: int
    createdAt: datetime
    updatedAt: datetime

    @classmethod
    def from_model(cls: type[Self], model: UserModel) -> Self:
        return cls(
            userId=model.userId,
            name=model.name,
            icon_kind=model.icon_kind,
            createdAt=model.createdAt,
            updatedAt=model.updatedAt,
        )
