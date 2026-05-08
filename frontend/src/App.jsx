import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useNavigate, useLocation } from 'react-router-dom';
import { Leaf, LogOut, ChartLine, Box, Map as MapIcon, Search, Building, Plus } from 'lucide-react';
import './index.css';

const API_BASE_URL = 'https://chaincacao-production-363c.up.railway.app/api/v1';

function App() {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('cc_token'));
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (token) {
      fetch(`${API_BASE_URL}/auth/me`, {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      .then(res => {
        if (!res.ok) throw new Error("Token expiré");
        return res.json();
      })
      .then(data => setUser(data))
      .catch(() => {
        setToken(null);
        localStorage.removeItem('cc_token');
      })
      .finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, [token]);

  const handleLogin = (data, jwt) => {
    localStorage.setItem('cc_token', jwt);
    setToken(jwt);
    setUser(data);
  };

  const handleLogout = () => {
    localStorage.removeItem('cc_token');
    setToken(null);
    setUser(null);
  };

  if (loading) return <div className="login-view view active"><p>Chargement...</p></div>;

  return (
    <Router>
      <div id="root">
        {user ? (
          <div className="main-layout">
            <Sidebar user={user} onLogout={handleLogout} />
            <main className="main-content">
              <Routes>
                <Route path="/dashboard" element={<Dashboard user={user} token={token} />} />
                <Route path="/lots" element={<Lots user={user} token={token} />} />
                <Route path="/parcelles" element={<Parcelles user={user} token={token} />} />
                <Route path="/traceability" element={<Traceability token={token} />} />
                <Route path="*" element={<Navigate to="/dashboard" replace />} />
              </Routes>
            </main>
          </div>
        ) : (
          <Routes>
            <Route path="/login" element={<Login onLogin={handleLogin} />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        )}
      </div>
    </Router>
  );
}

function Sidebar({ user, onLogout }) {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { path: '/dashboard', label: 'Tableau de Bord', icon: <ChartLine size={20} /> },
    { path: '/lots', label: 'Lots de Cacao', icon: <Box size={20} /> },
    { path: '/parcelles', label: 'Parcelles (EUDR)', icon: <MapIcon size={20} /> },
    { path: '/validation', label: 'Validation Acteurs', icon: <Building size={20} /> },
    { path: '/traceability', label: 'Explorateur Trace', icon: <Search size={20} /> }
  ];

  return (
    <nav className="sidebar">
      <div className="logo">
        <Leaf /> ChainCacao
      </div>
      <ul className="nav-links">
        {navItems.map(item => {
          if (item.path === '/parcelles' && user.role !== 'PRODUCTEUR') return null;
          if (item.path === '/validation' && user.role !== 'MINISTERE' && user.role !== 'COOPERATIVE') return null;
          return (
            <li key={item.path}>
              <a 
                onClick={() => navigate(item.path)} 
                className={location.pathname === item.path ? 'active' : ''}
              >
                {item.icon} {item.label}
              </a>
            </li>
          );
        })}
      </ul>
      <div className="user-info">
        <div className="avatar"><i className="fa-solid fa-user"></i></div>
        <div className="details">
          <span className="user-name">{user.full_name || user.email}</span>
          <span className="user-role">{user.role}</span>
        </div>
        <button onClick={onLogout} className="logout-btn">
          <LogOut size={20} />
        </button>
      </div>
    </nav>
  );
}

function Login({ onLogin }) {
  const [isLoginView, setIsLoginView] = useState(true);
  
  // Login State
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  
  // Register State
  const [fullName, setFullName] = useState('');
  const [role, setRole] = useState('PRODUCTEUR');
  const [telephone, setTelephone] = useState('');
  const [file, setFile] = useState(null);

  const [cooperatives, setCooperatives] = useState([]);
  const [selectedCoop, setSelectedCoop] = useState('');

  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    fetch(`${API_BASE_URL}/auth/cooperatives/public`)
      .then(res => res.json())
      .then(data => {
        if(Array.isArray(data)) {
          setCooperatives(data);
        }
      })
      .catch(err => console.error("Erreur chargement coopératives:", err));
  }, []);

  const handleLoginSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    setSuccess('');

    const formData = new URLSearchParams();
    formData.append('username', email);
    formData.append('password', password);

    try {
      const res = await fetch(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Erreur d'authentification");
      
      onLogin(data.user, data.access_token);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const handleRegisterSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    setSuccess('');

    if (['COOPERATIVE', 'EXPORTATEUR', 'CERTIF'].includes(role) && !file) {
      setError("Le document de preuve de légalité est obligatoire pour ce rôle.");
      setIsLoading(false);
      return;
    }

    const formData = new FormData();
    formData.append('email', email);
    formData.append('password', password);
    formData.append('full_name', fullName);
    formData.append('role', role);
    if (telephone) formData.append('numero_telephone', telephone);
    if (file) formData.append('file', file);
    if (role === 'PRODUCTEUR' && selectedCoop) formData.append('cooperative_id', selectedCoop);

    try {
      const res = await fetch(`${API_BASE_URL}/auth/register`, {
        method: 'POST',
        body: formData
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Erreur lors de l'inscription");
      
      setSuccess("Inscription réussie ! En attente de validation par l'administrateur.");
      setIsLoginView(true);
      setPassword('');
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <section className="login-view view active">
      <div className="login-container glass-panel" style={{ maxWidth: '500px' }}>
        <div className="login-header">
          <Leaf size={48} className="pulse-anim" style={{ color: 'var(--primary)', margin: '0 auto' }} />
          <h1>ChainCacao</h1>
          <p>Réseau Blockchain EUDR</p>
        </div>
        
        <div className="auth-tabs" style={{ display: 'flex', marginBottom: '20px', gap: '10px' }}>
          <button 
            className={`btn-primary ${!isLoginView ? 'inactive' : ''}`} 
            style={{ flex: 1, backgroundColor: isLoginView ? 'var(--primary)' : 'transparent', color: isLoginView ? '#fff' : 'var(--text-color)', border: '1px solid var(--primary)' }}
            onClick={() => { setIsLoginView(true); setError(''); setSuccess(''); }}
          >
            Connexion
          </button>
          <button 
            className={`btn-primary ${isLoginView ? 'inactive' : ''}`} 
            style={{ flex: 1, backgroundColor: !isLoginView ? 'var(--primary)' : 'transparent', color: !isLoginView ? '#fff' : 'var(--text-color)', border: '1px solid var(--primary)' }}
            onClick={() => { setIsLoginView(false); setError(''); setSuccess(''); }}
          >
            S'inscrire
          </button>
        </div>

        {error && <p style={{color: '#ef4444', marginBottom: '15px', padding: '10px', backgroundColor: 'rgba(239, 68, 68, 0.1)', borderRadius: '5px'}}>{error}</p>}
        {success && <p style={{color: '#10b981', marginBottom: '15px', padding: '10px', backgroundColor: 'rgba(16, 185, 129, 0.1)', borderRadius: '5px'}}>{success}</p>}

        {isLoginView ? (
          <form onSubmit={handleLoginSubmit} id="login-form">
            <div className="input-group">
              <label>Adresse Email / Identifiant</label>
              <input type="email" placeholder="Email" required value={email} onChange={e => setEmail(e.target.value)} />
            </div>
            <div className="input-group">
              <label>Mot de passe</label>
              <input type="password" placeholder="Mot de passe" required value={password} onChange={e => setPassword(e.target.value)} />
            </div>
            <button type="submit" className="btn-primary" disabled={isLoading} style={{ width: '100%', padding: '15px', marginTop: '10px' }}>
              {isLoading ? "Connexion en cours..." : "Se connecter au réseau"}
            </button>
          </form>
        ) : (
          <form onSubmit={handleRegisterSubmit} id="register-form">
            <div className="input-group">
              <label>Nom Complet / Raison Sociale</label>
              <input type="text" placeholder="Ex: Jean Dupont ou Coop Cacao" required value={fullName} onChange={e => setFullName(e.target.value)} />
            </div>
            <div className="input-group">
              <label>Rôle</label>
              <select value={role} onChange={e => setRole(e.target.value)}>
                <option value="PRODUCTEUR">Producteur</option>
                <option value="COOPERATIVE">Coopérative</option>
                <option value="EXPORTATEUR">Exportateur</option>
                <option value="CERTIF">Certificateur</option>
              </select>
            </div>
            {role === 'PRODUCTEUR' && (
              <div className="input-group">
                <label>Coopérative de rattachement</label>
                <select value={selectedCoop} onChange={e => setSelectedCoop(e.target.value)}>
                  <option value="">-- Indépendant ou À définir --</option>
                  {cooperatives.map(c => (
                    <option key={c.blockchain_id} value={c.blockchain_id}>{c.full_name}</option>
                  ))}
                </select>
              </div>
            )}
            <div style={{display: 'flex', gap: '10px'}}>
              <div className="input-group" style={{flex: 1}}>
                <label>Email</label>
                <input type="email" placeholder="Email" required value={email} onChange={e => setEmail(e.target.value)} />
              </div>
              <div className="input-group" style={{flex: 1}}>
                <label>Téléphone</label>
                <input type="tel" placeholder="Optionnel" value={telephone} onChange={e => setTelephone(e.target.value)} />
              </div>
            </div>
            <div className="input-group">
              <label>Mot de passe</label>
              <input type="password" placeholder="Créer un mot de passe" required value={password} onChange={e => setPassword(e.target.value)} />
            </div>
            
            {['COOPERATIVE', 'EXPORTATEUR', 'CERTIF'].includes(role) && (
              <div className="input-group" style={{ backgroundColor: 'rgba(243, 156, 18, 0.1)', padding: '10px', borderRadius: '5px', border: '1px solid #F39C12' }}>
                <label style={{ color: '#F39C12' }}>Document de Légalité Requis (Kbis, Statuts...)</label>
                <input type="file" required onChange={e => setFile(e.target.files[0])} />
                <small style={{ color: '#aaa' }}>Votre inscription devra être validée par le Ministère.</small>
              </div>
            )}
            
            <button type="submit" className="btn-primary" disabled={isLoading} style={{ width: '100%', padding: '15px', marginTop: '10px' }}>
              {isLoading ? "Envoi en cours..." : "Créer mon Identité Blockchain"}
            </button>
          </form>
        )}
      </div>
    </section>
  );
}

function Dashboard({ user, token }) {
  const navigate = useNavigate();

  return (
    <section className="view active">
      <header className="topbar">
        <h2>Tableau de bord</h2>
        <div className="network-status">
          <span className="status-dot"></span> Connecté à Fabric
        </div>
      </header>
      
      <div className="actions-section glass-panel">
        <h3>Actions Rapides ({user.role})</h3>
        <div className="action-buttons">
          {user.role === 'PRODUCTEUR' && (
            <>
              <button className="action-btn" onClick={() => navigate('/lots')}><Leaf size={18} /> Déclarer une récolte</button>
              <button className="action-btn" onClick={() => navigate('/parcelles')}><MapIcon size={18} /> Gérer mes parcelles</button>
            </>
          )}
          {user.role === 'COOPERATIVE' && (
            <>
              <button className="action-btn" onClick={() => navigate('/lots')}><Box size={18} /> Regrouper des lots</button>
              <button className="action-btn" onClick={() => navigate('/validation')}><Building size={18} /> Valider des producteurs</button>
            </>
          )}
          {user.role === 'EXPORTATEUR' && <button className="action-btn"><Box size={18} /> Expédier lot (Export)</button>}
          {user.role === 'MINISTERE' && (
            <>
              <button className="action-btn" onClick={() => navigate('/validation')}><Building size={18} /> Valider les institutions</button>
              <button className="action-btn" onClick={() => navigate('/traceability')}><Search size={18} /> Auditer les lots EUDR</button>
            </>
          )}
        </div>
      </div>
    </section>
  );
}

function Validation({ user, token }) {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const [validatingId, setValidatingId] = useState(null);
  const [filterType, setFilterType] = useState('PENDING');

  // Formulaire Producteur (Coopérative uniquement)
  const [newProdName, setNewProdName] = useState('');
  const [newProdPhone, setNewProdPhone] = useState('');
  const [isCreatingProd, setIsCreatingProd] = useState(false);

  useEffect(() => {
    fetchPendingUsers();
  }, [user, filterType]);

  const fetchPendingUsers = () => {
    setLoading(true);
    let endpoint = '';
    
    if (user.role === 'MINISTERE') {
      endpoint = filterType === 'PENDING' ? `${API_BASE_URL}/auth/pending-registrations` : `${API_BASE_URL}/auth/users`;
    } else if (user.role === 'COOPERATIVE') {
      endpoint = `${API_BASE_URL}/auth/users?role=PRODUCTEUR`;
    } else {
      setLoading(false);
      return;
    }

    fetch(endpoint, {
      headers: { 'Authorization': `Bearer ${token}` },
      cache: 'no-store'
    })
    .then(res => res.json())
    .then(data => {
      if (Array.isArray(data)) {
        let filtered = data;
        if (filterType === 'PENDING') {
          filtered = data.filter(u => !u.blockchain_validated);
        } else if (filterType === 'VALIDATED') {
          filtered = data.filter(u => u.blockchain_validated);
        }
        setUsers(filtered);
      }
    })
    .catch(console.error)
    .finally(() => setLoading(false));
  };

  const handleValidate = async (targetUser) => {
    if (!window.confirm(`Valider l'inscription de ${targetUser.full_name} sur la Blockchain ?`)) return;
    
    setValidatingId(targetUser.blockchain_id);
    
    const payload = {
      actorIdHash: targetUser.blockchain_id,
      typeActeur: targetUser.role,
      clePublique: "cle_publique_generique_ed25519", // Simplifié pour le prototype
      orgName: targetUser.org_name
    };

    try {
      const res = await fetch(`${API_BASE_URL}/actors/register`, {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json' 
        },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      
      if (!res.ok) throw new Error(data.detail || "Erreur lors de la validation");
      
      alert(`✅ Acteur ${targetUser.full_name} validé et inscrit sur le registre Hyperledger Fabric avec succès !`);
      fetchPendingUsers(); // Rafraîchir la liste
    } catch (err) {
      alert(err.message);
    } finally {
      setValidatingId(null);
    }
  };

  const handleCreateProducer = async (e) => {
    e.preventDefault();
    setIsCreatingProd(true);

    const payload = {
      fullName: newProdName,
      numeroTelephone: newProdPhone
    };

    try {
      const res = await fetch(`${API_BASE_URL}/auth/register-producer`, {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json' 
        },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      
      if (!res.ok) throw new Error(data.detail || "Erreur d'inscription du producteur");
      
      alert(`✅ Producteur ${data.full_name} inscrit ! Il est maintenant en attente de validation.`);
      setNewProdName('');
      setNewProdPhone('');
      fetchPendingUsers();
    } catch (err) {
      alert(err.message);
    } finally {
      setIsCreatingProd(false);
    }
  };

  if (user.role !== 'MINISTERE' && user.role !== 'COOPERATIVE') {
    return <section className="view active"><p>Accès refusé.</p></section>;
  }

  return (
    <section className="view active">
      <header className="topbar">
        <h2>Validation des Acteurs (Inscription Blockchain)</h2>
        <div style={{display: 'flex', gap: '15px', alignItems: 'center'}}>
          <select value={filterType} onChange={e => setFilterType(e.target.value)} style={{padding: '8px', borderRadius: '5px', border: '1px solid #ccc', backgroundColor: '#fff', color: '#333'}}>
            <option value="PENDING">En attente de validation</option>
            <option value="VALIDATED">Déjà validés</option>
            <option value="ALL">Tous les acteurs</option>
          </select>
          <button className="btn-primary" onClick={fetchPendingUsers} disabled={loading} style={{ padding: '8px 15px', display: 'flex', alignItems: 'center', gap: '8px', backgroundColor: 'var(--primary)' }}>
            {loading ? "Chargement..." : "↻ Rafraîchir"}
          </button>
        </div>
      </header>

      {user.role === 'COOPERATIVE' && (
        <div className="glass-panel" style={{ marginBottom: '20px', padding: '20px' }}>
          <h3 style={{ marginBottom: '15px', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Leaf size={20} /> Inscrire un nouveau Producteur (Membre)
          </h3>
          <form onSubmit={handleCreateProducer} style={{ display: 'flex', gap: '15px', alignItems: 'flex-end', flexWrap: 'wrap' }}>
            <div className="input-group" style={{ flex: '1', minWidth: '200px', marginBottom: 0 }}>
              <label>Nom Complet du Producteur</label>
              <input type="text" required value={newProdName} onChange={e => setNewProdName(e.target.value)} placeholder="Ex: Koffi Mensah" />
            </div>
            <div className="input-group" style={{ flex: '1', minWidth: '200px', marginBottom: 0 }}>
              <label>Numéro de Téléphone</label>
              <input type="tel" required value={newProdPhone} onChange={e => setNewProdPhone(e.target.value)} placeholder="Ex: 90123456" />
            </div>
            <button type="submit" className="btn-primary" disabled={isCreatingProd} style={{ height: '42px', padding: '0 20px' }}>
              {isCreatingProd ? "Inscription..." : "+ Ajouter Producteur"}
            </button>
          </form>
          <small style={{ color: '#aaa', display: 'block', marginTop: '10px' }}>
            Le producteur sera créé localement. Vous devrez ensuite l'approuver dans la liste ci-dessous pour l'inscrire sur la Blockchain. Le mot de passe par défaut est son numéro de téléphone.
          </small>
        </div>
      )}

      <div className="glass-panel table-container">
        {loading ? <p style={{padding: '20px'}}>Chargement des demandes...</p> : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Nom / Raison Sociale</th>
                <th>Rôle</th>
                <th>ID Blockchain</th>
                <th>Document de Légalité</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map(u => (
                <tr key={u.blockchain_id}>
                  <td><strong>{u.full_name}</strong><br/><small>{u.email || u.numero_telephone}</small></td>
                  <td><span className="badge warning">{u.role}</span></td>
                  <td style={{fontFamily: 'monospace', fontSize: '0.85rem'}}>{u.blockchain_id}</td>
                  <td>
                    {u.document_legalite_hash ? (
                      <span style={{color: 'var(--primary)', cursor: 'pointer'}}>📄 Voir Document</span>
                    ) : (
                      <span style={{color: '#aaa'}}>Aucun</span>
                    )}
                  </td>
                  <td>
                    {!u.blockchain_validated ? (
                      <button 
                        className="btn-primary" 
                        style={{ padding: '5px 15px', fontSize: '0.8rem', backgroundColor: '#10b981', borderColor: '#10b981' }} 
                        onClick={() => handleValidate(u)}
                        disabled={validatingId === u.blockchain_id}
                      >
                        {validatingId === u.blockchain_id ? "Enregistrement Fabric..." : "✅ Approuver"}
                      </button>
                    ) : (
                      <span className="badge success">✅ Inscrit sur Fabric</span>
                    )}
                  </td>
                </tr>
              ))}
              {users.length === 0 && <tr><td colSpan="5" style={{textAlign: 'center', padding: '20px'}}>Aucun résultat pour cette sélection.</td></tr>}
            </tbody>
          </table>
        )}
      </div>
    </section>
  );
}

function Parcelles({ user, token }) {
  const [parcelles, setParcelles] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showModal, setShowModal] = useState(false);
  
  const [parcelleId, setParcelleId] = useState('');
  const [culture, setCulture] = useState('Cacao');
  const [surface, setSurface] = useState('');
  const [lat, setLat] = useState('');
  const [lng, setLng] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchParcelles();
  }, []);

  const fetchParcelles = () => {
    setLoading(true);
    fetch(`${API_BASE_URL}/parcelles/me`, {
      headers: { 'Authorization': `Bearer ${token}` }
    })
    .then(res => res.json())
    .then(data => {
      if(Array.isArray(data)) setParcelles(data);
    })
    .catch(console.error)
    .finally(() => setLoading(false));
  };

  const handleCreate = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      const payload = {
        parcelle_id: parcelleId,
        gps: { latitude: parseFloat(lat), longitude: parseFloat(lng) },
        culture,
        surface: parseFloat(surface)
      };

      const res = await fetch(`${API_BASE_URL}/parcelles/`, {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Erreur de création");
      
      alert("Parcelle inscrite sur la blockchain !");
      setShowModal(false);
      fetchParcelles();
    } catch (err) {
      alert(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <section className="view active">
      <header className="topbar">
        <h2>Mes Parcelles EUDR</h2>
        <button className="btn-primary" onClick={() => setShowModal(true)}>
          <Plus size={18} /> Nouvelle Parcelle
        </button>
      </header>

      <div className="glass-panel table-container">
        {loading ? <p style={{padding: '20px'}}>Chargement...</p> : (
          <table className="data-table">
            <thead>
              <tr>
                <th>ID Parcelle</th>
                <th>Surface (Ha)</th>
                <th>Culture</th>
                <th>GPS</th>
              </tr>
            </thead>
            <tbody>
              {parcelles.map(p => (
                <tr key={p.parcelle_id || p.Record?.parcelle_id}>
                  <td><strong>{p.parcelle_id || p.Record?.parcelle_id}</strong></td>
                  <td>{p.surface || p.Record?.surface} ha</td>
                  <td>{p.culture || p.Record?.culture}</td>
                  <td>{p.gps?.latitude || p.Record?.gps?.latitude}, {p.gps?.longitude || p.Record?.gps?.longitude}</td>
                </tr>
              ))}
              {parcelles.length === 0 && <tr><td colSpan="4" style={{textAlign: 'center', padding: '20px'}}>Aucune parcelle</td></tr>}
            </tbody>
          </table>
        )}
      </div>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content glass-panel">
            <div className="modal-header">
              <h3>Enregistrer une Parcelle</h3>
              <button className="close-modal" onClick={() => setShowModal(false)}>&times;</button>
            </div>
            <form onSubmit={handleCreate}>
              <div className="input-group">
                <label>ID Parcelle (ex: PARC-001)</label>
                <input type="text" required value={parcelleId} onChange={e => setParcelleId(e.target.value)} />
              </div>
              <div className="input-group">
                <label>Surface (Hectares)</label>
                <input type="number" step="0.1" required value={surface} onChange={e => setSurface(e.target.value)} />
              </div>
              <div style={{display: 'flex', gap: '10px'}}>
                <div className="input-group" style={{flex: 1}}>
                  <label>Latitude</label>
                  <input type="number" step="0.000001" required value={lat} onChange={e => setLat(e.target.value)} />
                </div>
                <div className="input-group" style={{flex: 1}}>
                  <label>Longitude</label>
                  <input type="number" step="0.000001" required value={lng} onChange={e => setLng(e.target.value)} />
                </div>
              </div>
              <button type="submit" className="btn-primary" disabled={isSubmitting}>
                {isSubmitting ? "Inscription..." : "Enregistrer Parcelle"}
              </button>
            </form>
          </div>
        </div>
      )}
    </section>
  );
}

function Lots({ user, token }) {
  const [lots, setLots] = useState([]);
  const [parcelles, setParcelles] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [loadingLots, setLoadingLots] = useState(false);
  const navigate = useNavigate();

  // Nouveau Lot State
  const [parcelleId, setParcelleId] = useState('');
  const [poidsKg, setPoidsKg] = useState('');
  const [espece, setEspece] = useState('Forastero');
  const [file, setFile] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (user.role === 'PRODUCTEUR' && user.blockchain_id) {
      setLoadingLots(true);
      fetch(`${API_BASE_URL}/audit/query/farmer/${user.blockchain_id}`, {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      .then(res => res.json())
      .then(data => {
        if(Array.isArray(data)) setLots(data);
      })
      .catch(console.error)
      .finally(() => setLoadingLots(false));

      // Fetch parcelles for the dropdown
      fetch(`${API_BASE_URL}/parcelles/me`, {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      .then(res => res.json())
      .then(data => {
        if(Array.isArray(data)) {
          setParcelles(data);
          if (data.length > 0) {
            setParcelleId(data[0].parcelle_id || data[0].Record?.parcelle_id);
          }
        }
      })
      .catch(console.error);
    }
  }, [user, token]);

  const handleCreate = async (e) => {
    e.preventDefault();
    if (!file) return alert("Veuillez joindre une photo de la récolte !");
    if (!parcelleId) return alert("Vous devez d'abord créer une parcelle !");
    
    setIsSubmitting(true);
    const formData = new FormData();
    formData.append('parcelle_id', parcelleId);
    formData.append('poids_kg', poidsKg);
    formData.append('espece', espece);
    formData.append('date_collecte', new Date().toISOString().split('T')[0]);
    formData.append('file', file);

    try {
      const res = await fetch(`${API_BASE_URL}/lots/`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` },
        body: formData
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Erreur de création du lot");
      
      alert("Lot inscrit sur la blockchain ! ID: " + data.lot_id);
      setShowModal(false);
      window.location.reload(); 
    } catch (err) {
      alert(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <section className="view active">
      <header className="topbar">
        <h2>Gestion des Lots</h2>
        {user.role === 'PRODUCTEUR' && (
          <button className="btn-primary" onClick={() => setShowModal(true)}>
            <Plus size={18} /> Nouveau Lot
          </button>
        )}
      </header>
      
      <div className="glass-panel table-container">
        {loadingLots ? <p style={{padding: '20px'}}>Chargement depuis la blockchain...</p> : (
          <table className="data-table">
            <thead>
              <tr>
                <th>ID Lot</th>
                <th>Poids</th>
                <th>Espèce</th>
                <th>Statut</th>
                <th>Date</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {lots.map(lot => (
                <tr key={lot.lotHash || lot.Record?.lotHash}>
                  <td><strong>{lot.lotHash || lot.Record?.lotHash}</strong></td>
                  <td>{lot.poidsKg || lot.Record?.poidsKg} kg</td>
                  <td>{lot.espece || lot.Record?.espece}</td>
                  <td><span className="badge success">{lot.statut || lot.Record?.statut}</span></td>
                  <td>{lot.dateCollecte || lot.Record?.dateCollecte}</td>
                  <td>
                    <button className="btn-primary" style={{ padding: '5px 10px', fontSize: '0.8rem' }} 
                            onClick={() => navigate('/traceability', { state: { lotId: lot.lotHash || lot.Record?.lotHash } })}>
                      Tracer QR
                    </button>
                  </td>
                </tr>
              ))}
              {lots.length === 0 && <tr><td colSpan="6" style={{textAlign: 'center', padding: '20px'}}>Aucun lot trouvé</td></tr>}
            </tbody>
          </table>
        )}
      </div>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content glass-panel">
            <div className="modal-header">
              <h3>Créer un Lot de Cacao</h3>
              <button className="close-modal" onClick={() => setShowModal(false)}>&times;</button>
            </div>
            {parcelles.length === 0 ? (
              <p style={{color: '#F39C12'}}>Vous devez enregistrer une parcelle avant de pouvoir créer un lot.</p>
            ) : (
              <form onSubmit={handleCreate}>
                <div className="input-group">
                  <label>Parcelle d'Origine (Obligatoire EUDR)</label>
                  <select required value={parcelleId} onChange={e => setParcelleId(e.target.value)}>
                    {parcelles.map(p => {
                      const id = p.parcelle_id || p.Record?.parcelle_id;
                      return <option key={id} value={id}>{id}</option>;
                    })}
                  </select>
                </div>
                <div className="input-group">
                  <label>Poids (kg)</label>
                  <input type="number" step="0.1" required value={poidsKg} onChange={e => setPoidsKg(e.target.value)} />
                </div>
                <div className="input-group">
                  <label>Espèce</label>
                  <select required value={espece} onChange={e => setEspece(e.target.value)}>
                    <option value="Forastero">Forastero</option>
                    <option value="Trinitario">Trinitario</option>
                    <option value="Criollo">Criollo</option>
                  </select>
                </div>
                <div className="input-group">
                  <label>Photo de la récolte (Preuve)</label>
                  <input type="file" accept="image/*" required onChange={e => setFile(e.target.files[0])} />
                </div>
                <button type="submit" className="btn-primary" disabled={isSubmitting}>
                  {isSubmitting ? "Inscription Blockchain..." : "Enregistrer sur la Blockchain"}
                </button>
              </form>
            )}
          </div>
        </div>
      )}
    </section>
  );
}

function Traceability({ token }) {
  const location = useLocation();
  const [query, setQuery] = useState(location.state?.lotId || '');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (location.state?.lotId) {
      handleSearch(location.state.lotId);
    }
  }, [location.state]);

  const handleSearchClick = () => handleSearch(query);

  const handleSearch = async (lotHash) => {
    if (!lotHash) return;
    setLoading(true);
    setError('');
    setResult(null);

    try {
      const res = await fetch(`${API_BASE_URL}/audit/verify/${lotHash}`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Lot introuvable");
      setResult(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="view active">
      <header className="topbar">
        <h2>Explorateur de Traçabilité (Vérification EUDR)</h2>
      </header>
      
      <div className="search-trace glass-panel">
        <input type="text" placeholder="Entrez le Hash du Lot (ex: LOT-20260502-XXX)" value={query} onChange={e => setQuery(e.target.value)} />
        <button className="btn-primary" onClick={handleSearchClick} disabled={loading}>
          <Search size={18} /> {loading ? "Recherche..." : "Tracer"}
        </button>
      </div>

      {error && <p style={{color: '#ef4444', padding: '20px'}}>{error}</p>}

      {result && (
        <div className="trace-result glass-panel" style={{ padding: '20px' }}>
          <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '20px'}}>
            <div>
              <h3 style={{color: 'var(--primary)', marginBottom: '10px'}}>{result.product}</h3>
              <p><strong>ID:</strong> {result.lot_id}</p>
              {result.blockchain_verified && <p style={{color: 'var(--primary)', fontWeight: 'bold', marginTop: '10px'}}><Leaf size={16}/> Vérifié sur Hyperledger Fabric</p>}
            </div>
            {result.origin_photo && (
              <img src={`${API_BASE_URL.replace('/api/v1', '')}${result.origin_photo}`} alt="Récolte" style={{width: '150px', borderRadius: '8px', border: '1px solid var(--glass-border)'}} />
            )}
          </div>
          
          <h4>Parcours du Lot :</h4>
          <div className="timeline">
            {result.journey?.map((step, idx) => (
              <div className="timeline-item" key={idx} style={{borderColor: step.step === 'MINISTERE' ? 'var(--primary)' : 'var(--glass-border)'}}>
                <h4><Box size={16} /> Étape : {step.step}</h4>
                <p><strong>Date:</strong> {new Date(step.date).toLocaleString()}</p>
                <p style={{ fontFamily: 'monospace', color: 'var(--primary)', marginTop: '5px', fontSize: '0.8rem' }}>TxID: {step.txId}</p>
              </div>
            ))}
            {(!result.journey || result.journey.length === 0) && (
              <div className="timeline-item">
                <h4><Leaf size={16} /> Création Initiale</h4>
                <p><strong>Date:</strong> {result.harvest_info?.date}</p>
                <p><strong>Poids:</strong> {result.harvest_info?.weight} kg</p>
              </div>
            )}
          </div>
        </div>
      )}
    </section>
  );
}

export default App;
