import pytest
import io
import os

def test_create_lot_unauthorized(client):
    """Should fail if no token is provided."""
    data = {
        "latitude": "6.1234",
        "longitude": "1.1234",
        "poids_kg": "120.5",
        "espece": "Forastero",
        "date_collecte": "2026-05-02"
    }
    response = client.post("/api/v1/lots/", data=data)
    assert response.status_code == 401

def test_create_lot_success(client, auth_headers, mock_blockchain):
    """Full lot creation flow with mocked blockchain."""
    # Setup mock return value
    mock_blockchain["invoke"].return_value = {"success": True, "txId": "mock-tx-123"}
    
    data = {
        "latitude": "6.1234",
        "longitude": "1.1234",
        "poids_kg": "120.5",
        "espece": "Forastero",
        "date_collecte": "2026-05-02"
    }
    
    # Create a dummy image
    file_content = b"fake image content"
    file = (io.BytesIO(file_content), "test_image.png")
    
    response = client.post(
        "/api/v1/lots/",
        data=data,
        files={"file": file},
        headers=auth_headers
    )
    
    assert response.status_code == 201
    res_json = response.json()
    assert res_json["success"] is True
    assert "lot_id" in res_json
    assert res_json["media"]["hash"] is not None
    
    # Verify blockchain was called
    assert mock_blockchain["invoke"].called

def test_get_lot_details(client, mock_blockchain):
    """Test retrieving lot details from blockchain."""
    lot_id = "LOT-20260502-TEST"
    mock_blockchain["get_lot"].return_value = {
        "lotHash": lot_id,
        "statut": "COLLECTE",
        "poidsKg": 100
    }
    
    response = client.get(f"/api/v1/lots/{lot_id}")
    
    assert response.status_code == 200
    assert response.json()["success"] is True
    assert response.json()["data"]["lotHash"] == lot_id

def test_get_media_not_found(client):
    """Should return 404 for non-existent media."""
    response = client.get("/api/v1/lots/media/non-existent-hash")
    assert response.status_code == 404
