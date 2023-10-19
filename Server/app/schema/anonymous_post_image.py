import os
from datetime import datetime
from typing import TypeVar

from pydantic import BaseModel

from app import settings
from app.models.anonymous_post_image import AnonymousPostImage as ImageModel

Self = TypeVar("Self", bound="AnonymousPostImage")


class AnonymousPostImage(BaseModel):
    id: int
    anonymousPostId: int
    imageURL: str
    createdAt: datetime
    updatedAt: datetime

    @classmethod
    def from_model(cls: type[Self], model: ImageModel) -> Self:
        return cls(
            id=model.id,
            anonymousPostId=model.anonymousPostId,
            imageURL=cls.get_imageURL_from_name(model.fileName),
            createdAt=model.createdAt,
            updatedAt=model.updatedAt,
        )

    @staticmethod
    def get_imageURL_from_name(name: str) -> str:
        path = os.path.join(settings.PUBLIC_MEDIA_IMAGE_ANONYMOUS_POST_PATH, name)
        return f"{settings.ORIGIN}{path}"
