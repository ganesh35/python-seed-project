from pydantic import BaseModel
from typing import Optional


class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None


class ItemOut(ItemCreate):
    id: str
