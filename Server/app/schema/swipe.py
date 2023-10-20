from typing import TypeVar

from pydantic import BaseModel

from app.models.anonymous_post import AnonymousPost as PostModel
from app.schema.anonymous_post_image import AnonymousPostImage as PostImageSchema


class SwipeAnonymousPostRequest(BaseModel):
    latitude: float
    longitude: float
    radius: int  # km


Self = TypeVar("Self", bound="SwipeAnonymousPost")


class SwipeAnonymousPost(BaseModel):
    googleMapShopId: str
    imageURL: str
    star: float

    @classmethod
    def from_model_list(cls: type[Self], model_list: list[PostModel]) -> list[Self]:
        res: list[Self] = []
        for model in model_list:
            for image in model.anonymousPostImages:
                res.append(
                    cls(
                        googleMapShopId=model.googleMapShopId,
                        star=model.star,
                        imageURL=PostImageSchema.get_imageURL_from_name(image.fileName),
                    )
                )

        return res
