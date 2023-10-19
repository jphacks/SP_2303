from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, relationship

from app.db import Base

if TYPE_CHECKING:
    from app.models.anonymous_post import AnonymousPost


class AnonymousPostImage(Base):
    """
    匿名投稿の画像モデル
    """

    __tablename__ = "anonymous_post_image"
    __table_args__ = {"comment": "Swipe UIに使用する匿名投稿用の画像パスを保存するテーブル"}

    id: int = Column("id", Integer, primary_key=True, autoincrement=True)
    anonymousPostId: int = Column(
        "anonymous_post_id",
        Integer,
        ForeignKey("anonymous_post.id", onupdate="CASCADE", ondelete="CASCADE"),
        nullable=False,
    )
    fileName: str = Column(
        "file_name",
        String(200),
        nullable=False,
    )

    anonymousPost: Mapped[AnonymousPost] = relationship(
        "AnonymousPost", back_populates="anonymousPostImages"
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
