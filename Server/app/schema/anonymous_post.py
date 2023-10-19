from datetime import datetime
from typing import TypeVar

from fastapi import UploadFile
from pydantic import BaseModel, Field

from app.models.anonymous_post import AnonymousPost as PostModel
from app.schema.anonymous_post_image import AnonymousPostImage as ImageSchema


class AnonymousPostCreate(BaseModel):
    timelineId: int = Field(description="端末で保存されているタイムラインのID")
    googleMapShopId: str
    star: float
    imageList: list[UploadFile]


class AnonymousPostDelete(BaseModel):
    timelineId: int = Field(description="端末で保存されているタイムラインのID")


Self = TypeVar("Self", bound="AnonymousPost")


class AnonymousPost(BaseModel):
    id: int
    userId: str
    timelineId: int = Field(description="端末で保存されているタイムラインのID")
    googleMapShopId: str
    star: float
    imageList: list[ImageSchema]
    createdAt: datetime
    updatedAt: datetime

    @classmethod
    def from_model(cls: type[Self], model: PostModel) -> Self:
        imageList: list[ImageSchema] = list(
            map(lambda x: ImageSchema.from_model(x), model.anonymousPostImages)
        )
        return cls(
            id=model.id,
            userId=model.userId,
            timelineId=model.timelineId,
            googleMapShopId=model.googleMapShopId,
            star=model.star,
            createdAt=model.createdAt,
            updatedAt=model.updatedAt,
            imageList=imageList,
        )
