'use strict';

const Schemas = require('../models/Schemas');
const LedgerService = require('../services/LedgerService');
const Validation = require('../utils/Validation');

class ParcelleLogic {
    constructor(ctx) {
        this.ctx = ctx;
        this.ledger = new LedgerService(ctx);
    }

    async registerParcelle(parcelleId, farmerId, gpsStr, culture, surface) {
        const gps = JSON.parse(gpsStr);
        Validation.checkGPS(gps);

        if (await this.ledger.exists(parcelleId)) {
            throw new Error(`PARCELLE_EXISTE: La parcelle ${parcelleId} existe deja.`);
        }

        const parcelle = {
            docType: 'parcelle',
            parcelleId,
            farmerId,
            gps,
            culture,
            surface: parseFloat(surface),
            dateEnregistrement: new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString()
        };

        await this.ledger.putState(parcelleId, parcelle);
        return parcelle;
    }

    async getParcelle(parcelleId) {
        const parcelle = await this.ledger.getState(parcelleId);
        if (!parcelle || parcelle.docType !== 'parcelle') {
            throw new Error(`PARCELLE_NON_TROUVE: ${parcelleId}`);
        }
        return parcelle;
    }

    async queryParcellesByFarmer(farmerId) {
        const query = {
            selector: {
                docType: 'parcelle',
                farmerId: farmerId
            }
        };
        const iterator = await this.ctx.stub.getQueryResult(JSON.stringify(query));
        const results = [];
        let res = await iterator.next();
        while (!res.done) {
            if (res.value && res.value.value.toString()) {
                results.push(JSON.parse(res.value.value.toString()));
            }
            res = await iterator.next();
        }
        await iterator.close();
        return results;
    }
}

module.exports = ParcelleLogic;
