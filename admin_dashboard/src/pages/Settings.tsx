import { useState, useEffect } from 'react';
import { Users, Dumbbell, Calendar } from 'lucide-react';

interface Stats {
  totalUsers: number;
  totalWorkouts: number;
}

function Settings() {
  const [stats, setStats] = useState<Stats>({ totalUsers: 0, totalWorkouts: 0 });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    setIsLoading(true);
    try {
      const [usersRes, workoutsRes] = await Promise.all([
        fetch('http://localhost:5000/api/v1/admin/users'),
        fetch('http://localhost:5000/api/v1/admin/workouts')
      ]);

      const usersData = await usersRes.json();
      const workoutsData = await workoutsRes.json();

      if (usersData.success && workoutsData.success) {
        setStats({
          totalUsers: usersData.data.length,
          totalWorkouts: workoutsData.data.length
        });
      }
    } catch (err) {
      console.error('Failed to fetch stats:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const StatCard = ({ icon: Icon, label, value, color }: any) => (
    <div style={{
      background: '#1a1f28',
      padding: '24px',
      borderRadius: '12px',
      display: 'flex',
      alignItems: 'center',
      gap: '16px'
    }}>
      <div style={{
        width: '56px',
        height: '56px',
        borderRadius: '12px',
        background: `${color}20`,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
      }}>
        <Icon size={28} color={color} />
      </div>
      <div>
        <div style={{ fontSize: '14px', color: '#9ca3af', marginBottom: '4px' }}>
          {label}
        </div>
        <div style={{ fontSize: '32px', fontWeight: '700', color: '#fff' }}>
          {isLoading ? '...' : value}
        </div>
      </div>
    </div>
  );

  return (
    <main className="main-content">
      <h1>Settings</h1>

      {/* Database Overview Section */}
      <section style={{ marginBottom: '32px' }}>
        <h2 style={{
          fontSize: '20px',
          fontWeight: '600',
          marginBottom: '16px',
          color: '#fff'
        }}>
          Database Overview
        </h2>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(2, 1fr)',
          gap: '20px',
          maxWidth: '600px'
        }}>
          <StatCard
            icon={Users}
            label="Total Users"
            value={stats.totalUsers}
            color="#10b981"
          />
          <StatCard
            icon={Dumbbell}
            label="Total Workouts Created"
            value={stats.totalWorkouts}
            color="#f59e0b"
          />
        </div>
      </section>

      {/* App Info Section */}
      <section style={{ marginBottom: '32px' }}>
        <h2 style={{
          fontSize: '20px',
          fontWeight: '600',
          marginBottom: '16px',
          color: '#fff'
        }}>
          Application Info
        </h2>
        <div style={{
          background: '#1a1f28',
          padding: '24px',
          borderRadius: '12px'
        }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', paddingBottom: '16px', borderBottom: '1px solid #2d3748' }}>
              <span style={{ color: '#9ca3af' }}>App Name</span>
              <span style={{ color: '#fff', fontWeight: '600' }}>FitTrack Pro</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', paddingBottom: '16px', borderBottom: '1px solid #2d3748' }}>
              <span style={{ color: '#9ca3af' }}>Version</span>
              <span style={{ color: '#fff', fontWeight: '600' }}>1.0.0</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', paddingBottom: '16px', borderBottom: '1px solid #2d3748' }}>
              <span style={{ color: '#9ca3af' }}>Backend URL</span>
              <span style={{ color: '#fff', fontWeight: '600' }}>http://localhost:5000</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ color: '#9ca3af' }}>Database Status</span>
              <span style={{
                color: '#10b981',
                fontWeight: '600',
                display: 'flex',
                alignItems: 'center',
                gap: '8px'
              }}>
                <div style={{
                  width: '8px',
                  height: '8px',
                  borderRadius: '50%',
                  background: '#10b981'
                }}></div>
                Connected
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* Quick Stats */}
      <section>
        <h2 style={{
          fontSize: '20px',
          fontWeight: '600',
          marginBottom: '16px',
          color: '#fff'
        }}>
          Quick Stats
        </h2>
        <div style={{
          background: '#1a1f28',
          padding: '24px',
          borderRadius: '12px'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '16px' }}>
            <Calendar size={20} color="#9ca3af" />
            <span style={{ color: '#9ca3af' }}>Dashboard Last Updated</span>
          </div>
          <div style={{ color: '#fff', fontSize: '16px', fontWeight: '600' }}>
            {new Date().toLocaleDateString('en-US', {
              weekday: 'long',
              year: 'numeric',
              month: 'long',
              day: 'numeric'
            })}
          </div>
        </div>
      </section>
    </main>
  );
}

export default Settings;