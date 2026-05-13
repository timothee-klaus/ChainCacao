'use strict';

/**
 * Strict Validation utility for business models.
 */
class Validation {
    /**
     * Generic required field check.
     */
    static checkRequired(obj, fields) {
        for (const field of fields) {
            if (obj[field] === undefined || obj[field] === null || obj[field] === '') {
                throw new Error(`VALIDATION_ERREUR: Le champ [${field}] est obligatoire.`);
            }
        }
    }

    /**
     * Check if value is a valid number.
     */
    static checkNumber(value, fieldName) {
        if (typeof value !== 'number' || isNaN(value)) {
            throw new Error(`VALIDATION_ERREUR: Le champ [${fieldName}] doit être un nombre.`);
        }
    }

    /**
     * Check if value is a valid timestamp (ISO String or Number).
     */
    static checkTimestamp(value, fieldName) {
        if (!value || isNaN(Date.parse(value))) {
            throw new Error(`VALIDATION_ERREUR: Le champ [${fieldName}] doit être un timestamp valide.`);
        }
    }

    /**
     * Check GPS structure (can be a single point or an array of points for a polygon).
     */
    static checkGPS(gps) {
        if (!gps) {
            throw new Error(`VALIDATION_ERREUR: Le champ [gps] est manquant.`);
        }
        
        const checkPoint = (point) => {
            if (typeof point.latitude !== 'number' || typeof point.longitude !== 'number') {
                throw new Error(`VALIDATION_ERREUR: Un point GPS doit contenir latitude et longitude (nombres).`);
            }
        };

        if (Array.isArray(gps)) {
            if (gps.length < 3) {
                throw new Error(`VALIDATION_ERREUR: Un polygone GPS doit contenir au moins 3 points.`);
            }
            gps.forEach(checkPoint);
        } else {
            // Rétrocompatibilité : point unique
            checkPoint(gps);
        }
    }

    /**
     * Check if string matches a hash format (simple check for non-empty string here, can be hex regex).
     */
    static checkHash(hash, fieldName) {
        if (typeof hash !== 'string' || hash.length < 8) {
            throw new Error(`VALIDATION_ERREUR: Le champ [${fieldName}] n'est pas un hash valide.`);
        }
    }
}

module.exports = Validation;
