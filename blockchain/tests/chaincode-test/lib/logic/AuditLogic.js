'use strict';

const LedgerService = require('../services/LedgerService');

class AuditLogic {
    constructor(ctx) {
        this.ctx = ctx;
        this.ledger = new LedgerService(ctx);
    }

    async getHistory(assetHash) {
        return await this.ledger.getHistory(assetHash);
    }

    async queryLotsByStatus(statut) {
        const query = { selector: { docType: 'lot', statut: statut } };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(query));
    }

    async queryCertifications(refHash) {
        const query = { selector: { docType: 'certification', referenceHash: refHash } };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(query));
    }

    async queryLotsByFarmer(farmerId) {
        // Recherche directe par farmerId puisque le champ est désormais public dans le lot
        const lotQuery = {
            selector: {
                docType: 'lot',
                farmerId: farmerId
            }
        };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(lotQuery));
    }

    async queryLotsByOwner(ownerId) {
        // Recherche par propriétaire actuel (celui qui a reçu le dernier transfert)
        const lotQuery = {
            selector: {
                docType: 'lot',
                ownerId: ownerId
            }
        };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(lotQuery));
    }

    async queryTransfersByUser(userId) {
        // Recherche tous les transferts où l'utilisateur est impliqué
        const query = {
            selector: {
                docType: 'transfer',
                $or: [
                    { expediteurId: userId },
                    { destinataireId: userId }
                ]
            }
        };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(query));
    }
}

module.exports = AuditLogic;
