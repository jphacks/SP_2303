from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import Column, DateTime, Float, Integer, String
from sqlalchemy.orm import Mapped, relationship

from app.db import Base

if TYPE_CHECKING:
    from app.models.anonymous_post import AnonymousPost


class GoogleMapShop(Base):
    """
    GoogleMapの店情報を保存するテーブル
    """

    __tablename__ = "google_map_shop"
    __table_args__ = {"comment": "GoogleMapのshopIdに対応した情報を、APIを叩く回数を減らすために保存する。"}

    id: int = Column("id", Integer, primary_key=True, autoincrement=True)
    googleMapShopId: str = Column(
        "google_map_shop_id", String(200), nullable=False, unique=True
    )
    # float型が認識されないので、型チェックを無視する
    latitude: float = Column(  # type: ignore
        "latitude",
        Float(),
        nullable=False,
    )
    longitude: float = Column(  # type: ignore
        "longitude",
        Float(),
        nullable=False,
    )
    anonymousPosts: Mapped[list[AnonymousPost]] = relationship(
        "AnonymousPost", back_populates="googleMapShop"
    )

    createdAt: datetime = Column(
        "created_at", DateTime, default=datetime.now(), nullable=False
    )
    updatedAt: datetime = Column(
        "updated_at",
        DateTime,
        default=datetime.now(),
        onupdate=datetime.now(),
        nullable=False,
    )
