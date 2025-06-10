from fastapi import APIRouter, HTTPException
from app.schemas import ItemCreate, ItemOut
from app.models import Item
from typing import List

router = APIRouter()
items = {}


@router.post("/", response_model=ItemOut)
def create_item(item: ItemCreate):
    new_item = Item(name=item.name, description=item.description)
    items[new_item.id] = new_item
    return new_item


@router.get("/", response_model=List[ItemOut])
def list_items():
    return list(items.values())


@router.get("/{item_id}", response_model=ItemOut)
def get_item(item_id: str):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return items[item_id]


@router.put("/{item_id}", response_model=ItemOut)
def update_item(item_id: str, item: ItemCreate):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    items[item_id].name = item.name
    items[item_id].description = item.description
    return items[item_id]


@router.delete("/{item_id}")
def delete_item(item_id: str):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    del items[item_id]
    return {"message": "Item deleted"}
