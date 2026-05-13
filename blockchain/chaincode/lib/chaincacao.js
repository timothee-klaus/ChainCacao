'use strict';

const { Contract } = require('fabric-contract-api');
const AccessControl = require('./utils/AccessControl');
const LedgerService = require('./services/LedgerService');
const ActorLogic = require('./logic/ActorLogic');
const LotLogic = require('./logic/LotLogic');
const TraceabilityLogic = require('./logic/TraceabilityLogic');
const AuditLogic = require('./logic/AuditLogic');
const ParcelleLogic = require('./logic/ParcelleLogic');

class ChainCacaoContract extends Contract {

    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
    }

    // =========================================================================
    // ACTEURS
    // =========================================================================

    async RegisterActor(ctx, actorIdHash, typeActeur, clePublique, metadata = '{}') {
        const callerMSP = ctx.clientIdentity.getMSPID();
        const callerId = AccessControl.getCallerId(ctx);

        // Hiérarchie de contrôle
        if (callerMSP === AccessControl.ROLES.MINISTERE || callerMSP === AccessControl.ROLES.TEST) {
            // Le Ministère ou l'organisation de TEST peut enregistrer n'importe qui
        } else if (callerMSP === AccessControl.ROLES.PRODUCTEUR) {
            // Une Coopérative (MSP Producteur) ne peut enregistrer que des producteurs
            if (typeActeur !== 'PRODUCTEUR') {
                throw new Error(`ACCES_REFUSE: Une coopérative ne peut enregistrer que des producteurs.`);
            }
        } else if (callerMSP === AccessControl.ROLES.CERTIFICATEUR) {
            // Un certificateur peut enregistrer des entités s'il a reçu mandat
        } else {
            throw new Error(`ACCES_REFUSE: Votre organisation (${callerMSP}) n'est pas autorisée à effectuer cette action.`);
        }


        const logic = new ActorLogic(ctx);
        const result = await logic.registerActor(actorIdHash, typeActeur, clePublique, callerId, metadata);
        return JSON.stringify(result);
    }

    async GetActor(ctx, actorIdHash) {
        const logic = new ActorLogic(ctx);
        const result = await logic.getActor(actorIdHash);
        return JSON.stringify(result);
    }

    // =========================================================================
    // PARCELLES
    // =========================================================================

    async RegisterParcelle(ctx, parcelleId, farmerId, gpsStr, culture, surface) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR]);
        const logic = new ParcelleLogic(ctx);
        const result = await logic.registerParcelle(parcelleId, farmerId, gpsStr, culture, surface);
        return JSON.stringify(result);
    }

    async GetParcelle(ctx, parcelleId) {
        const logic = new ParcelleLogic(ctx);
        const result = await logic.getParcelle(parcelleId);
        return JSON.stringify(result);
    }

    async GetFarmerParcelles(ctx, farmerId) {
        const logic = new ParcelleLogic(ctx);
        const result = await logic.queryParcellesByFarmer(farmerId);
        return JSON.stringify(result);
    }

    // =========================================================================
    // LOTS
    // =========================================================================

    async CreateLot(ctx, lotHash, farmerId, parcelleId, poidsKg, espece, dateCollecte, mediaHash, coopId) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR, AccessControl.ROLES.CERTIFICATEUR]);
        const logic = new LotLogic(ctx);
        const result = await logic.createLot(lotHash, farmerId, parcelleId, poidsKg, espece, dateCollecte, mediaHash, coopId);
        return JSON.stringify(result);
    }

    async GetLot(ctx, lotHash) {
        const logic = new LotLogic(ctx);
        const result = await logic.getLot(lotHash);
        return JSON.stringify(result);
    }


    async UpdateLotStatus(ctx, lotHash, nouveauStatut) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR, AccessControl.ROLES.CERTIFICATEUR, AccessControl.ROLES.EXPORTATEUR]);
        const logic = new LotLogic(ctx);
        const result = await logic.updateStatus(lotHash, nouveauStatut);
        return JSON.stringify(result);
    }

    async AddCertification(ctx, certHash, lotHash, verificateurId, statut, rapportHash) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.CERTIFICATEUR, AccessControl.ROLES.MINISTERE]);
        const logic = new LotLogic(ctx);
        const result = await logic.addCertification(certHash, lotHash, verificateurId, statut, rapportHash);
        return JSON.stringify(result);
    }

    async CreateBundle(ctx, bundleHash, lotHashesStr, coopId) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR]);
        const logic = new LotLogic(ctx);
        const result = await logic.createBundle(bundleHash, JSON.parse(lotHashesStr), coopId);
        return JSON.stringify(result);
    }

    // =========================================================================
    // TRANSFERTS / TRANSFORMATIONS / EXPEDITIONS
    // =========================================================================

    async CreateTransfer(ctx, transferHash, lotHashesStr, expediteurId, destinataireId, preuveHash, transporteurId = "") {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR, AccessControl.ROLES.EXPORTATEUR, AccessControl.ROLES.TRANSFORMATEUR]);
        const logic = new TraceabilityLogic(ctx);
        const result = await logic.createTransfer(transferHash, JSON.parse(lotHashesStr), expediteurId, destinataireId, preuveHash, transporteurId);
        return JSON.stringify(result);
    }

    async CreateTransformation(ctx, transformationHash, lotHashesStr, typeProcessus, preuveHash) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.EXPORTATEUR, AccessControl.ROLES.TRANSFORMATEUR]);
        
        const callerId = AccessControl.getCallerId(ctx);
        const lotHashes = JSON.parse(lotHashesStr);
        const logic = new TraceabilityLogic(ctx);
        const result = await logic.createTransformation(transformationHash, lotHashes, typeProcessus, preuveHash, callerId);
        return JSON.stringify(result);
    }

    async CreateShipment(ctx, shipmentHash, lotHashesStr, exportateurId, destination, documentsHash, dateDepart, dateArrivee) {
        AccessControl.checkRole(ctx, [AccessControl.ROLES.EXPORTATEUR]);
        const logic = new TraceabilityLogic(ctx);
        const result = await logic.createShipment(shipmentHash, JSON.parse(lotHashesStr), exportateurId, destination, documentsHash, dateDepart, dateArrivee);
        return JSON.stringify(result);
    }

    async CreateTransportEvent(ctx, eventHash, refHash, transporteurIdHash, typeEvenement, gpsStr, preuveHash) {
        // Transport can be logged by Producers, Exporters, Transformers or a dedicated role if added later.
        AccessControl.checkRole(ctx, [AccessControl.ROLES.PRODUCTEUR, AccessControl.ROLES.EXPORTATEUR, AccessControl.ROLES.TRANSFORMATEUR]);
        const logic = new TraceabilityLogic(ctx);
        const result = await logic.createTransportEvent(eventHash, refHash, transporteurIdHash, typeEvenement, gpsStr, preuveHash);
        return JSON.stringify(result);
    }

    // =========================================================================
    // REQUETES AVANCEES / AUDIT
    // =========================================================================

    async GetHistoryForAsset(ctx, assetHash) {
        const logic = new AuditLogic(ctx);
        const result = await logic.getHistory(assetHash);
        return JSON.stringify(result);
    }

    async QueryLotsByStatus(ctx, statut) {
        const logic = new AuditLogic(ctx);
        const result = await logic.queryLotsByStatus(statut);
        return JSON.stringify(result);
    }

    async QueryCertifications(ctx, refHash) {
        const logic = new AuditLogic(ctx);
        const result = await logic.queryCertifications(refHash);
        return JSON.stringify(result);
    }

    async QueryLotsByFarmer(ctx, farmerId) {
        const logic = new AuditLogic(ctx);
        const result = await logic.queryLotsByFarmer(farmerId);
        return JSON.stringify(result);
    }
}

module.exports = ChainCacaoContract;
