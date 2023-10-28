from datetime import datetime
from typing import TypeVar

from pydantic import BaseModel

from app.models.google_map_shop import GoogleMapShop as ShopModel

Self = TypeVar("Self", bound="GoogleMapShop")


class GoogleMapShop(BaseModel):
    googleMapShopId: str
    latitude: float
    longitude: float
    name: str
    address: str

    @classmethod
    def from_model(cls: type[Self], model: ShopModel) -> Self:
        return cls(
            googleMapShopId=model.googleMapShopId,
            latitude=model.latitude,
            longitude=model.longitude,
            name=model.name,
            address=model.address,
        )
