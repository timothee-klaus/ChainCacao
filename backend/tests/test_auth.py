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

def test_register_cooperative_with_file_by_ministry(client, db):
    # 1. Create a Ministry user first
    from security import get_password_hash
    ministry_user = User(
        email="admin@ministere.tg",
        hashed_password=get_password_hash("password123"),
        full_name="Admin Ministère",
        role="MINISTERE",
        org_name="ministere",
        blockchain_id="min-admin"
    )
    db.add(ministry_user)
    db.commit()

    # 2. Login as Ministry
    login_res = client.post("/api/v1/auth/login", data={"username": "admin@ministere.tg", "password": "password123"})
    token = login_res.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    # 3. Create Cooperative
    data = {
        "email": "coop@test.com",
        "password": "password123",
        "full_name": "Ma Coop",
        "role": "COOPERATIVE",
        "org_name": "producteurs"
    }
    files = {"file": ("agrement.pdf", b"fake-pdf-content", "application/pdf")}
    response = client.post("/api/v1/auth/register", data=data, files=files, headers=headers)
    assert response.status_code == 201

def test_register_cooperative_fails_without_ministry(client):
    data = {
        "email": "coop_unauth@test.com",
        "password": "password123",
        "full_name": "Unauthorized Coop",
        "role": "COOPERATIVE",
        "org_name": "producteurs"
    }
    files = {"file": ("agrement.pdf", b"fake-pdf-content", "application/pdf")}
    response = client.post("/api/v1/auth/register", data=data, files=files)
    assert response.status_code == 403
    assert "Seul le Ministère" in response.json()["detail"]

def test_register_cooperative_fails_without_file(client):
    data = {
        "email": "coop_fail@test.com",
        "password": "password123",
        "full_name": "Fail Coop",
        "role": "COOPERATIVE",
        "org_name": "producteurs"
    }
    response = client.post("/api/v1/auth/register", data=data)
    assert response.status_code == 400
    assert "preuve de légalité est obligatoire" in response.json()["detail"]
