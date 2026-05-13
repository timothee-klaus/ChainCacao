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
        // Étape 1 : Récupérer toutes les parcelles du fermier
        const parcelleQuery = {
            selector: { docType: 'parcelle', farmerId: farmerId }
        };
        const parcelleIterator = await this.ctx.stub.getQueryResult(JSON.stringify(parcelleQuery));
        const parcelleIds = [];
        let res = await parcelleIterator.next();
        
        while (!res.done) {
            if (res.value && res.value.value.toString()) {
                const parcelle = JSON.parse(res.value.value.toString());
                parcelleIds.push(parcelle.parcelleId);
            }
            res = await parcelleIterator.next();
        }
        await parcelleIterator.close();

        if (parcelleIds.length === 0) {
            return []; // Aucune parcelle trouvée, donc aucun lot
        }

        // Étape 2 : Récupérer les lots associés à ces parcelles
        const lotQuery = {
            selector: {
                docType: 'lot',
                parcelleId: { "$in": parcelleIds }
            }
        };
        return await this.ledger.getQueryResultForQueryString(JSON.stringify(lotQuery));
    }
}

module.exports = AuditLogic;
