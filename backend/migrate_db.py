import sys
import os

# Ajouter le chemin parent pour pouvoir importer database
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import engine, User
from sqlalchemy import text

def migrate():
    print("Vérification de la structure de la table 'users'...")
    with engine.connect() as conn:
        # Liste des colonnes attendues
        expected_columns = {
            "document_legalite_path": "VARCHAR",
            "document_legalite_hash": "VARCHAR",
            "is_admin": "BOOLEAN DEFAULT FALSE",
            "parent_id": "VARCHAR"
        }
        
        for col, type_info in expected_columns.items():
            try:
                # Tentative d'ajout de la colonne
                print(f"Tentative d'ajout de la colonne '{col}'...")
                conn.execute(text(f"ALTER TABLE users ADD COLUMN {col} {type_info}"))
                conn.commit()
                print(f"✅ Colonne '{col}' ajoutée avec succès.")
            except Exception as e:
                if "already exists" in str(e).lower() or "duplicate column" in str(e).lower():
                    print(f"ℹ️ La colonne '{col}' existe déjà.")
                else:
                    print(f"❌ Erreur lors de l'ajout de '{col}': {e}")
    
    print("Migration terminée.")

if __name__ == "__main__":
    migrate()
