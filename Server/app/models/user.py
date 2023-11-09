from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, DateTime, Integer, String, UniqueConstraint

from app.db.base_class import Base


class User(Base):
    """
    ユーザーモデル
    """

    __tablename__ = "user"
    __table_args__ = (
        {"comment": "ユーザー設定に関するテーブル"},
    )

    userId: str = Column("user_id", String(200), primary_key=True, nullable=False)
    name: str = Column("name", String(200), nullable=False)
    iconKind: int = Column(
        "icon_kind",
        Integer(),
        nullable=False,
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
