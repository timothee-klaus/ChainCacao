'use strict';

const Schemas = require('../models/Schemas');
const LedgerService = require('../services/LedgerService');

class TraceabilityLogic {
    constructor(ctx) {
        this.ctx = ctx;
        this.ledger = new LedgerService(ctx);
    }

    async createTransfer(transferHash, lotHashes, expediteurId, destinataireId, preuveHash, transporteurId = null) {
        // Validation existence
        for (const hash of lotHashes) {
            if (!(await this.ledger.exists(hash))) {
                throw new Error(`LOT_INEXISTANT: ${hash}`);
            }
        }

        const timestamp = new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString();
        
        // 1. Données du Transfert (100% publiques)
        const publicTransfer = {
            docType: 'transfer',
            transferHash: transferHash,
            lotHashes: lotHashes,
            timestamp: timestamp,
            transporteurId: transporteurId,
            expediteurId: expediteurId,
            destinataireId: destinataireId,
            preuveHash: preuveHash
        };
        await this.ledger.putState(transferHash, publicTransfer);
        
        // Update lots status & ownership (Public)
        for (const hash of lotHashes) {
            const lot = await this.ledger.getState(hash);
            if (lot) {
                lot.statut = `TRANSFERE`;
                lot.ownerId = destinataireId; // Mutation de propriété
                lot.dernierTransfertHash = transferHash;
                await this.ledger.putState(hash, lot);
            }
        }

        return publicTransfer;
    }

    async createTransformation(transformationHash, lotHashes, typeProcessus, preuveHash, transformateurId) {
        const timestamp = new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString();
        const transformation = Schemas.createTransformation(transformationHash, lotHashes, typeProcessus, timestamp, preuveHash, transformateurId);
        
        for (const hash of lotHashes) {
            const lot = await this.ledger.getState(hash);
            if (lot) {
                lot.statut = `TRANSFORME_${typeProcessus}`;
                lot.transformationHash = transformationHash;
                await this.ledger.putState(hash, lot);
            }
        }

        await this.ledger.putState(transformationHash, transformation);
        return transformation;
    }

    async createShipment(shipmentHash, lotHashes, exportateurId, destination, documentsHash, dateDepart, dateArrivee) {
        const timestamp = new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString();
        const shipment = Schemas.createShipment(shipmentHash, lotHashes, exportateurId, destination, documentsHash, dateDepart, dateArrivee, timestamp);
        
        for (const hash of lotHashes) {
            const lot = await this.ledger.getState(hash);
            if (lot) {
                lot.statut = `EXPEDIE_VERS_${destination}`;
                lot.shipmentHash = shipmentHash;
                await this.ledger.putState(hash, lot);
            }
        }

        await this.ledger.putState(shipmentHash, shipment);
        return shipment;
    }
}

module.exports = TraceabilityLogic;
