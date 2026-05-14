'use strict';

const Schemas = require('../models/Schemas');
const LedgerService = require('../services/LedgerService');
const Validation = require('../utils/Validation');

class LotLogic {
    constructor(ctx) {
        this.ctx = ctx;
        this.ledger = new LedgerService(ctx);
    }

    async createLot(lotHash, farmerId, parcelleId, poidsKg, espece, dateCollecte, mediaHash, coopId) {
        if (await this.ledger.exists(lotHash)) {
            throw new Error(`LOT_EXISTE: Le lot ${lotHash} existe deja.`);
        }

        // 1. Récupérer les infos de la parcelle pour le GPS
        const parcelle = await this.ledger.getState(parcelleId);
        if (!parcelle || parcelle.docType !== 'parcelle') {
            throw new Error(`PARCELLE_NON_TROUVE: La parcelle ${parcelleId} n'existe pas.`);
        }
        
        // Vérifier que le fermier est bien le propriétaire de la parcelle
        if (parcelle.farmerId !== farmerId) {
             throw new Error(`ACCES_REFUSE: Le fermier ${farmerId} n'est pas le propriétaire de la parcelle ${parcelleId}.`);
        }

        const gps = parcelle.gps;
        Validation.checkNumber(parseFloat(poidsKg), 'poidsKg');
        Validation.checkTimestamp(dateCollecte, 'dateCollecte');

        // 2. Données Publiques (visibles par tous)
        const publicLot = {
            docType: 'lot',
            lotHash: lotHash,
            farmerId: farmerId,
            parcelleId: parcelleId,
            espece: espece,
            poidsKg: parseFloat(poidsKg),
            dateCollecte: dateCollecte,
            statut: 'COLLECTE'
        };
        await this.ledger.putState(lotHash, publicLot);

        // 3. Données Privées (GPS, Farmer ID, Coop ID, etc.)
        const privateDetails = {
            lotHash: lotHash,
            coopId: coopId,
            gps: gps,
            mediaHash: mediaHash
        };
        
        // Utilisation de la collection privée
        await this.ctx.stub.putPrivateData('collectionPrivateLots', lotHash, Buffer.from(JSON.stringify(privateDetails)));

        return publicLot;
    }

    async getLot(lotHash) {
        const publicLot = await this.ledger.getState(lotHash);
        if (!publicLot) throw new Error(`LOT_NON_TROUVE: ${lotHash}`);

        // Tenter de récupérer les données privées
        try {
            const privateDataBuffer = await this.ctx.stub.getPrivateData('collectionPrivateLots', lotHash);
            if (privateDataBuffer && privateDataBuffer.length > 0) {
                const privateDetails = JSON.parse(privateDataBuffer.toString());
                return { ...publicLot, ...privateDetails };
            }
        } catch (e) {
            // Si l'organisation n'a pas accès, on ne renvoie que le public
            console.log(`Accès privé refusé pour ${lotHash}`);
        }

        return publicLot;
    }


    async updateStatus(lotHash, nouveauStatut) {
        const lot = await this.getLot(lotHash);
        lot.statut = nouveauStatut;
        await this.ledger.putState(lotHash, lot);
        return lot;
    }

    async addCertification(certHash, lotHash, verificateurId, statut, rapportHash) {
        if (!(await this.ledger.exists(lotHash))) {
            throw new Error(`LOT_NON_TROUVE: ${lotHash}`);
        }

        const timestamp = new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString();
        const certification = {
            docType: 'certification',
            certHash: certHash,
            lotHash: lotHash,
            verificateurId: verificateurId,
            statut: statut,
            rapportHash: rapportHash,
            dateCertification: timestamp
        };

        await this.ledger.putState(certHash, certification);

        // Optionnel : Mettre à jour le statut du lot si la certification est validée
        if (statut === 'VALIDE' || statut === 'COMPLIANT') {
            const lot = await this.getLot(lotHash);
            lot.statut = 'CERTIFIE';
            await this.ledger.putState(lotHash, lot);
        }

        return certification;
    }

    async createBundle(bundleHash, lotHashes, coopId) {
        if (await this.ledger.exists(bundleHash)) {
            throw new Error(`BUNDLE_EXISTE: Le regroupement ${bundleHash} existe deja.`);
        }

        let totalPoids = 0;
        const validatedLotHashes = [];

        for (const lotHash of lotHashes) {
            const lot = await this.getLot(lotHash);
            if (lot.statut !== 'COLLECTE' && lot.statut !== 'CERTIFIE') {
                throw new Error(`LOT_NON_DISPONIBLE: Le lot ${lotHash} est déjà regroupé ou transformé (Statut: ${lot.statut}).`);
            }
            totalPoids += lot.poidsKg;
            validatedLotHashes.push(lotHash);

            // Mettre à jour le statut du lot individuel
            lot.statut = 'REGROUPE';
            lot.bundleHash = bundleHash;
            await this.ledger.putState(lotHash, lot);
        }

        const timestamp = new Date(this.ctx.stub.getTxTimestamp().seconds.low * 1000).toISOString();
        
        // 1. Données Publiques du Bundle
        const publicBundle = {
            docType: 'bundle',
            bundleHash: bundleHash,
            lotHashes: validatedLotHashes,
            totalPoids: totalPoids,
            timestamp: timestamp,
            statut: 'REGROUPE'
        };
        await this.ledger.putState(bundleHash, publicBundle);

        // 2. Données Privées du Bundle (Coop ID)
        const privateBundle = {
            bundleHash: bundleHash,
            coopId: coopId
        };
        await this.ctx.stub.putPrivateData('collectionPrivateLots', bundleHash, Buffer.from(JSON.stringify(privateBundle)));

        return publicBundle;
    }
}

module.exports = LotLogic;
