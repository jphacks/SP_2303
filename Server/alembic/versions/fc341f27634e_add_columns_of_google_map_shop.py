"""add columns of google map shop

Revision ID: fc341f27634e
Revises: 22434124b09f
Create Date: 2023-10-24 12:02:46.789151

"""
from typing import Sequence, Union

import sqlalchemy as sa

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "fc341f27634e"
down_revision: Union[str, None] = "22434124b09f"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column(
        "google_map_shop", sa.Column("name", sa.String(length=200), nullable=False)
    )
    op.add_column(
        "google_map_shop", sa.Column("address", sa.String(length=200), nullable=False)
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column("google_map_shop", "address")
    op.drop_column("google_map_shop", "name")
    # ### end Alembic commands ###
