from typing import Optional
from uuid import uuid4


class Item:
    def __init__(self, name: str, description: Optional[str] = None):
        self.id = str(uuid4())
        self.name = name
        self.description = description
