import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from fastapi.testclient import TestClient
import os
import sys

# Ensure backend directory is in the path
backend_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if backend_path not in sys.path:
    sys.path.append(backend_path)

from database import Base, get_db
from main import app

# Use SQLite for testing
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="session", autouse=True)
def setup_database():
    # Create the tables
    Base.metadata.create_all(bind=engine)
    yield
    # Clean up after tests
    if os.path.exists("./test.db"):
        try:
            os.remove("./test.db")
        except:
            pass

@pytest.fixture
def db():
    """
    Fixture to provide a clean database session for each test.
    Using a transaction-based approach for isolation.
    """
    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)

    yield session

    session.close()
    transaction.rollback()
    connection.close()

@pytest.fixture
def client(db):
    """
    Fixture to provide a TestClient with overridden get_db dependency.
    """
    def override_get_db():
        try:
            yield db
        finally:
            pass
    
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    # Cleanup overrides after the test
    app.dependency_overrides.clear()

@pytest.fixture
def auth_token(client):
    """
    Fixture to provide a valid JWT token for a test producer.
    """
    client.post("/api/v1/auth/setup-test-user")
    login_data = {
        "username": "prod@test.com",
        "password": "password123"
    }
    response = client.post("/api/v1/auth/login", data=login_data)
    return response.json()["access_token"]

@pytest.fixture
def auth_headers(auth_token):
    """
    Fixture to provide Authorization headers.
    """
    return {"Authorization": f"Bearer {auth_token}"}

@pytest.fixture
def mock_blockchain():
    """
    Fixture to mock the BlockchainGateway methods.
    """
    from services.blockchain_gateway import BlockchainGateway
    
    # We use patch from unittest.mock if pytest-mock is not available
    from unittest.mock import patch
    
    with patch("services.blockchain_gateway.BlockchainGateway.invoke_transaction") as mock_invoke:
        with patch("services.blockchain_gateway.BlockchainGateway.query_ledger") as mock_query:
            with patch("services.blockchain_gateway.BlockchainGateway.get_lot") as mock_get_lot:
                with patch("services.blockchain_gateway.BlockchainGateway.get_parcelle") as mock_get_parc:
                    yield {
                        "invoke": mock_invoke,
                        "query": mock_query,
                        "get_lot": mock_get_lot,
                        "get_parcelle": mock_get_parc
                    }

