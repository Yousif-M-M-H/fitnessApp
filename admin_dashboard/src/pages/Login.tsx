import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import authService from '../services/authService';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await authService.login({ email, password });

      // Check if user is admin
      if (response.user.role !== 'admin') {
        setError('Access denied. Admin privileges required.');
        authService.logout();
        return;
      }

      // Redirect to dashboard
      navigate('/');
      window.location.reload(); // Reload to fetch dashboard data
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
    }}>
      <div style={{
        background: '#0f3460',
        padding: '40px',
        borderRadius: '16px',
        width: '400px',
        boxShadow: '0 10px 40px rgba(0,0,0,0.3)',
      }}>
        <h1 style={{
          color: '#fff',
          marginBottom: '10px',
          fontSize: '28px',
          textAlign: 'center'
        }}>
          FitTrack Admin
        </h1>
        <p style={{
          color: '#9ca3af',
          marginBottom: '30px',
          textAlign: 'center'
        }}>
          Sign in to access the dashboard
        </p>

        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: '20px' }}>
            <label style={{
              display: 'block',
              color: '#e4e4e7',
              marginBottom: '8px',
              fontSize: '14px',
            }}>
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              style={{
                width: '100%',
                padding: '12px',
                borderRadius: '8px',
                border: '1px solid #374151',
                background: '#1f2937',
                color: '#fff',
                fontSize: '14px',
              }}
              placeholder="admin@example.com"
            />
          </div>

          <div style={{ marginBottom: '20px' }}>
            <label style={{
              display: 'block',
              color: '#e4e4e7',
              marginBottom: '8px',
              fontSize: '14px',
            }}>
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{
                width: '100%',
                padding: '12px',
                borderRadius: '8px',
                border: '1px solid #374151',
                background: '#1f2937',
                color: '#fff',
                fontSize: '14px',
              }}
              placeholder="••••••••"
            />
          </div>

          {error && (
            <div style={{
              background: '#dc2626',
              color: '#fff',
              padding: '12px',
              borderRadius: '8px',
              marginBottom: '20px',
              fontSize: '14px',
            }}>
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              padding: '12px',
              borderRadius: '8px',
              border: 'none',
              background: loading ? '#6b7280' : '#10b981',
              color: '#fff',
              fontSize: '16px',
              fontWeight: '600',
              cursor: loading ? 'not-allowed' : 'pointer',
            }}
          >
            {loading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login;
