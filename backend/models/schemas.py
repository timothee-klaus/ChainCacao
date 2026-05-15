from pydantic import BaseModel, Field, ConfigDict, field_validator, model_validator, EmailStr
from typing import List, Optional, Dict, Literal
import re

class GPSModel(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    latitude: float
    longitude: float

    @field_validator("latitude")
    @classmethod
    def validate_lat(cls, v: float) -> float:
        if not -90 <= v <= 90:
            raise ValueError("La latitude doit être entre -90 et 90")
        return v

    @field_validator("longitude")
    @classmethod
    def validate_lon(cls, v: float) -> float:
        if not -180 <= v <= 180:
            raise ValueError("La longitude doit être entre -180 et 180")
        return v

class ParcelleCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    farmer_id: Optional[str] = Field(None, alias="farmerId")

    gps: List[GPSModel] = Field(..., min_length=3, description="Au moins 3 points GPS pour délimiter le polygone de la parcelle")
    culture: str
    surface: float

class ParcelleResponse(ParcelleCreate):
    parcelle_id: str = Field(alias="parcelleId")
    date_enregistrement: str = Field(alias="dateEnregistrement")

class LotCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    lot_hash: str = Field(alias="lotHash")
    farmer_id: str = Field(alias="farmerId")
    parcelle_id: str = Field(alias="parcelleId")
    poids_kg: float = Field(alias="poidsKg")
    espece: str
    date_collecte: str = Field(alias="dateCollecte")
    media_hash: str = Field(alias="mediaHash")
    coop_id: Optional[str] = Field(None, alias="coopId")
    statut: str = Field(default="COLLECTE")

    @field_validator("lot_hash", "media_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

    @field_validator("date_collecte")
    @classmethod
    def validate_date(cls, v: str) -> str:
        if not re.match(r"^\d{4}-\d{2}-\d{2}$", v):
            raise ValueError("La date doit être au format YYYY-MM-DD")
        return v

class LotResponse(LotCreate):
    pass

class TransferCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    transfer_hash: str = Field(alias="transferHash")
    lot_hashes: List[str] = Field(alias="lotHashes")
    expediteur_id: str = Field(alias="expediteurId")
    destinataire_id: str = Field(alias="destinataireId")
    preuve_hash: str = Field(alias="preuveHash")

    @field_validator("transfer_hash", "preuve_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class TransformationCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    transformation_hash: str = Field(alias="transformationHash")
    lot_hashes: List[str] = Field(alias="lotHashes")
    type_processus: str = Field(alias="typeProcessus")
    preuve_hash: str = Field(alias="preuveHash")

    @field_validator("transformation_hash", "preuve_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class ShipmentCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    shipment_hash: str = Field(alias="shipmentHash")
    lot_hashes: List[str] = Field(alias="lotHashes")
    exportateur_id: str = Field(alias="exportateurId")
    destination: str
    documents_hash: str = Field(alias="documentsHash")
    date_depart_prevue: str = Field(alias="dateDepartPrevue")
    date_arrivee_prevue: str = Field(alias="dateArriveePrevue")

    @field_validator("shipment_hash", "documents_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

    @field_validator("date_depart_prevue", "date_arrivee_prevue")
    @classmethod
    def validate_date(cls, v: str) -> str:
        if not re.match(r"^\d{4}-\d{2}-\d{2}$", v):
            raise ValueError("La date doit être au format YYYY-MM-DD")
        return v

class TransportEventCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    event_hash: str = Field(alias="eventHash")
    ref_hash: str = Field(alias="refHash")
    transporteur_id_hash: str = Field(alias="transporteurIdHash")
    type_evenement: str = Field(alias="typeEvenement")
    gps: GPSModel
    preuve_hash: str = Field(alias="preuveHash")

    @field_validator("event_hash", "ref_hash", "preuve_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class CertificationCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    cert_hash: str = Field(alias="certHash")
    ref_hash: str = Field(alias="refHash")
    verificateur_id: str = Field(alias="verificateurId")
    statut: str
    rapport_hash: str = Field(alias="rapportHash")

    @field_validator("cert_hash", "ref_hash", "rapport_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class ActorRegister(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    actor_id_hash: str = Field(alias="actorIdHash")
    type_acteur: str = Field(alias="typeActeur")
    cle_publique: str = Field(alias="clePublique")
    org_name: str = Field(alias="orgName")

    @field_validator("actor_id_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class BundleCreate(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    bundle_hash: str = Field(alias="bundleHash")
    lot_hashes: List[str] = Field(alias="lotHashes")
    coop_id: str = Field(alias="coopId")

    @field_validator("bundle_hash")
    @classmethod
    def validate_hashes(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Le hash doit comporter au moins 8 caractères")
        return v

class ActorResponse(ActorRegister):
    date_enregistrement: str = Field(alias="dateEnregistrement")
    revoque: bool

ROLE_TO_ORG: Dict[str, str] = {
    "PRODUCTEUR": "producteurs",
    "COOPERATIVE": "cooperatives",
    "EXPORTATEUR": "exportateurs",
    "CERTIF": "certificats",
    "MINISTERE": "test",
    "TRANSFORMATEUR": "transformateurs",
}

class UserRegister(BaseModel):
    """Payload pour créer un compte utilisateur."""
    model_config = ConfigDict(populate_by_name=True)

    email: Optional[EmailStr] = None
    password: str = Field(min_length=8, description="Mot de passe (min 8 caractères)")
    full_name: str = Field(min_length=2)
    role: Literal["PRODUCTEUR", "COOPERATIVE", "EXPORTATEUR", "CERTIF", "MINISTERE", "TRANSFORMATEUR"]
    numero_telephone: Optional[str] = Field(None, description="Requis pour les producteurs")
    cooperative_id: Optional[str] = Field(None, alias="coopId", description="ID de la coopérative choisie")
    is_admin: bool = False

    @property
    def org_name(self) -> str:
        """Dérive automatiquement l'organisation Fabric depuis le rôle."""
        return ROLE_TO_ORG[self.role]

    @model_validator(mode='after')
    def validate_producer_phone(self) -> 'UserRegister':
        if self.role == "PRODUCTEUR" and not self.numero_telephone:
            raise ValueError("Le numéro de téléphone est requis pour un profil producteur")
        return self

class UserPublicResponse(BaseModel):
    """Profil utilisateur retourné après inscription / login (sans données sensibles)."""
    model_config = ConfigDict(populate_by_name=True, from_attributes=True)

    email: Optional[str] = None
    full_name: str
    numero_telephone: Optional[str] = None
    role: str
    org_name: str
    blockchain_id: str
    blockchain_validated: bool = False
    document_legalite_hash: Optional[str] = None

class ProducerRegisterDelegated(BaseModel):
    """Payload pour qu'une coopérative inscrive un producteur."""
    full_name: str = Field(..., min_length=2, alias="fullName")
    numero_telephone: str = Field(..., alias="numeroTelephone")
    location: Optional[str] = None

class AgentRegister(BaseModel):
    """Payload pour qu'un administrateur de coopérative inscrive un agent."""
    email: Optional[EmailStr] = None
    numero_telephone: Optional[str] = Field(None, alias="numeroTelephone")
    password: str = Field(min_length=8)
    full_name: str = Field(..., min_length=2, alias="fullName")

class TokenRefresh(BaseModel):
    """Payload pour rafraîchir un token d'accès."""
    refresh_token: str = Field(..., alias="refreshToken")
