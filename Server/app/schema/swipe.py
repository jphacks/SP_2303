from typing import TypeVar

from pydantic import BaseModel

from app.models.anonymous_post import AnonymousPost as PostModel
from app.schema.anonymous_post_image import AnonymousPostImage as PostImageSchema
from app.schema.googleMapShop import GoogleMapShop as GoogleMapShopSchema


class SwipeAnonymousPostRequest(BaseModel):
    latitude: float
    longitude: float
    radius: int  # km


Self = TypeVar("Self", bound="SwipeAnonymousPost")


class SwipeAnonymousPost(BaseModel):
    imageURL: str
    star: float
    googleMapShop: GoogleMapShopSchema

    @classmethod
    def from_model_list(cls: type[Self], model_list: list[PostModel]) -> list[Self]:
        res: list[Self] = []
        for model in model_list:
            for image in model.anonymousPostImages:
                res.append(
                    cls(
                        star=model.star,
                        imageURL=PostImageSchema.get_imageURL_from_name(image.fileName),
                        googleMapShop=GoogleMapShopSchema.from_model(
                            model.googleMapShop
                        ),
                    )
                )

        return res
