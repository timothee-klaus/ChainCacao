import pytest

def test_read_root(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == "Welcome to ChainCacao API"

def test_setup_test_user(client):
    # This endpoint creates a user in the DB
    response = client.post("/api/v1/auth/setup-test-user")
    assert response.status_code == 200
    assert "message" in response.json()
    assert "prod@test.com" in response.json()["message"]


def test_login_success(client):
    # First setup the user
    client.post("/api/v1/auth/setup-test-user")
    
    # Then login
    login_data = {
        "username": "prod@test.com",
        "password": "password123"
    }
    response = client.post("/api/v1/auth/login", data=login_data)
    assert response.status_code == 200
    assert "access_token" in response.json()
    assert response.json()["token_type"] == "bearer"
