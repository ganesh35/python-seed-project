import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_probe_info():
    response = client.get("/info")
    assert response.status_code == 200
    assert "app" in response.json()
    assert "version" in response.json()
    assert "commitId" in response.json()


def test_probe_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_probe_liveness():
    response = client.get("/liveness")
    assert response.status_code == 200
    assert response.json()["status"] == "alive"


def test_probe_readiness():
    response = client.get("/readiness")
    assert response.status_code == 200
    assert response.json()["status"] == "ready"


def test_create_and_crud_item():
    # Create
    item_data = {"name": "TestItem", "description": "A test item"}
    response = client.post("/items/", json=item_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == item_data["name"]
    assert data["description"] == item_data["description"]
    item_id = data["id"]

    # List
    response = client.get("/items/")
    assert response.status_code == 200
    items = response.json()
    assert any(i["id"] == item_id for i in items)

    # Get
    response = client.get(f"/items/{item_id}")
    assert response.status_code == 200
    assert response.json()["id"] == item_id

    # Update
    updated = {"name": "UpdatedName", "description": "Updated desc"}
    response = client.put(f"/items/{item_id}", json=updated)
    assert response.status_code == 200
    assert response.json()["name"] == updated["name"]

    # Delete
    response = client.delete(f"/items/{item_id}")
    assert response.status_code == 200
    assert response.json()["message"] == "Item deleted"

    # Get after delete
    response = client.get(f"/items/{item_id}")
    assert response.status_code == 404
