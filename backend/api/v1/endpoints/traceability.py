from fastapi import APIRouter, Depends, HTTPException, status
from models.schemas import TransferCreate, TransformationCreate, ShipmentCreate
from services.blockchain_gateway import BlockchainGateway
from database import User
import security

router = APIRouter()
gateway = BlockchainGateway()

@router.post("/transfers", status_code=status.HTTP_201_CREATED)
async def create_transfer(
    transfer: TransferCreate,
    current_user: User = Depends(security.get_current_user)
):
    """
    Record a ownership transfer between two actors.
    """
    try:
        return await gateway.create_transfer(
            transfer.model_dump(by_alias=True), 
            current_user.org_name, 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/transformations", status_code=status.HTTP_201_CREATED)
async def create_transformation(
    transformation: TransformationCreate,
    current_user: User = Depends(security.get_current_user)
):
    """
    Record an industrial transformation process.
    """
    try:
        data = transformation.model_dump(by_alias=True)
        args = [
            data['transformationHash'], 
            str(data['lotHashes']), 
            data['typeProcessus'], 
            data['preuveHash']
        ]
        return await gateway.invoke_transaction(
            "CreateTransformation", 
            args, 
            current_user.org_name, 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/shipments", status_code=status.HTTP_201_CREATED)
async def create_shipment(
    shipment: ShipmentCreate,
    current_user: User = Depends(security.get_current_user)
):
    """
    Register a new international shipment.
    Role: EXPORTATEUR
    """
    try:
        data = shipment.model_dump(by_alias=True)
        args = [
            data['shipmentHash'], str(data['lotHashes']), data['exportateurId'],
            data['destination'], data['documentsHash'], data['dateDepartPrevue'],
            data['dateArriveePrevue']
        ]
        return await gateway.invoke_transaction(
            "CreateShipment", 
            args, 
            current_user.org_name, 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
