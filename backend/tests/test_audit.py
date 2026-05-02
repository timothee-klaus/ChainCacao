import pytest

def test_get_asset_history(client, mock_blockchain):
    asset_id = "LOT-123"
    mock_blockchain["query"].return_value = [
        {"txId": "tx1", "value": {"statut": "COLLECTE"}},
        {"txId": "tx2", "value": {"statut": "TRANSIT"}}
    ]
    
    # Note: query_ledger is mocked, and get_history calls it
    # We need to make sure we mock the right thing based on gateway.py
    from unittest.mock import patch
    with patch("services.blockchain_gateway.BlockchainGateway.get_history") as mock_hist:
        mock_hist.return_value = [{"txId": "tx1"}]
        response = client.get(f"/api/v1/audit/history/{asset_id}")
        assert response.status_code == 200
        assert len(response.json()) == 1

def test_query_by_status(client, mock_blockchain):
    mock_blockchain["query"].return_value = [{"lotHash": "LOT-1"}]
    
    response = client.get("/api/v1/audit/query/status/COLLECTE")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_verify_lot_public(client, mock_blockchain):
    lot_id = "LOT-123"
    mock_blockchain["get_lot"].return_value = {
        "lotHash": lot_id,
        "dateCollecte": "2026-05-01",
        "mediaHash": "hash123"
    }
    # Mocking get_history for verify endpoint
    from unittest.mock import patch
    with patch("services.blockchain_gateway.BlockchainGateway.get_history") as mock_hist:
        mock_hist.return_value = [{"value": {"statut": "COLLECTE"}, "timestamp": "2026-05-01"}]
        
        response = client.get(f"/api/v1/audit/verify/{lot_id}")
        assert response.status_code == 200
        res = response.json()
        assert res["lot_id"] == lot_id
        assert res["blockchain_verified"] is True
        assert len(res["journey"]) > 0

def test_eudr_report_not_found(client, mock_blockchain):
    lot_id = "UNKNOWN"
    # gateway.get_eudr_report handles the error logic
    from unittest.mock import patch
    with patch("services.blockchain_gateway.BlockchainGateway.get_eudr_report") as mock_report:
        mock_report.return_value = {"success": False, "error": "LOT_NOT_FOUND"}
        response = client.get(f"/api/v1/audit/eudr-report/{lot_id}")
        assert response.status_code == 404
