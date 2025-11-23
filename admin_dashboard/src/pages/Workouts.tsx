import { Search, RefreshCw } from 'lucide-react';
import { useState, useEffect } from 'react';

interface Workout {
  _id: string;
  userName: string;
  workoutSplit: string;
  goal: string;
  fitnessLevel: string;
  gymDaysPerWeek: number;
  sessionDuration: string;
  createdAt: string;
}

function Workouts() {
  const [allWorkouts, setAllWorkouts] = useState<Workout[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [isRefreshing, setIsRefreshing] = useState(false);

  useEffect(() => {
    fetchWorkouts();
  }, []);

  const fetchWorkouts = () => {
    setIsRefreshing(true);
    fetch('http://localhost:5000/api/v1/admin/workouts')
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          setAllWorkouts(data.data);
        }
      })
      .catch(err => console.error('Failed to fetch workouts:', err))
      .finally(() => setIsRefreshing(false));
  };

  // Filter workouts based on search query
  const filteredWorkouts = allWorkouts.filter(workout => {
    const userName = workout.userName?.toLowerCase() || '';
    const workoutSplit = workout.workoutSplit?.toLowerCase() || '';
    const query = searchQuery.toLowerCase();
    return userName.includes(query) || workoutSplit.includes(query);
  });

  const formatGoal = (goal: string) => {
    const goalMap: { [key: string]: string } = {
      'lose_weight': 'Lose Weight',
      'gain_muscle': 'Gain Muscle',
      'fitness': 'Fitness'
    };
    return goalMap[goal] || goal;
  };

  const formatActivityLevel = (level: string) => {
    return level.charAt(0).toUpperCase() + level.slice(1);
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  };

  return (
    <main className="main-content">
      <h1>Workouts</h1>

      {/* Stats Card */}
      <div style={{
        background: '#1a1f28',
        padding: '24px',
        borderRadius: '12px',
        marginBottom: '32px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between'
      }}>
        <div>
          <div style={{ fontSize: '14px', color: '#9ca3af', marginBottom: '4px' }}>
            Total Workouts
          </div>
          <div style={{ fontSize: '42px', fontWeight: '700', color: '#10b981' }}>
            {allWorkouts.length}
          </div>
        </div>
        <button
          onClick={fetchWorkouts}
          disabled={isRefreshing}
          style={{
            background: '#10b981',
            color: '#0a0e14',
            border: 'none',
            padding: '12px 20px',
            borderRadius: '8px',
            cursor: isRefreshing ? 'not-allowed' : 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            fontSize: '14px',
            fontWeight: '600',
            opacity: isRefreshing ? 0.6 : 1
          }}
        >
          <RefreshCw size={18} style={{ animation: isRefreshing ? 'spin 1s linear infinite' : 'none' }} />
          Refresh
        </button>
      </div>

      {/* Search */}
      <div style={{ marginBottom: '24px' }}>
        <div className="search-box">
          <Search size={20} />
          <input
            type="text"
            placeholder="Search workouts..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
      </div>

      {/* Workouts Table */}
      <div className="table-container">
        {filteredWorkouts.length === 0 ? (
          <div style={{
            textAlign: 'center',
            padding: '60px 20px',
            color: '#9ca3af'
          }}>
            <div style={{ fontSize: '48px', marginBottom: '16px' }}>🏋️</div>
            <div style={{ fontSize: '18px', marginBottom: '8px', color: '#fff' }}>
              No workouts found
            </div>
            <div style={{ fontSize: '14px' }}>
              {searchQuery ? 'Try a different search term' : 'No workout plans in the database yet'}
            </div>
          </div>
        ) : (
          <table className="users-table">
            <thead>
              <tr>
                <th>User</th>
                <th>Workout Split</th>
                <th>Goal</th>
                <th>Level</th>
                <th>Days/Week</th>
                <th>Created</th>
              </tr>
            </thead>
            <tbody>
              {filteredWorkouts.map((workout) => (
                <tr key={workout._id}>
                  <td className="workout-name">{workout.userName || 'Unknown'}</td>
                  <td>{workout.workoutSplit || 'No split'}</td>
                  <td>{formatGoal(workout.goal)}</td>
                  <td>
                    <span className={`difficulty-badge ${workout.fitnessLevel?.toLowerCase()}`}>
                      {formatActivityLevel(workout.fitnessLevel)}
                    </span>
                  </td>
                  <td>{workout.gymDaysPerWeek} days</td>
                  <td>{formatDate(workout.createdAt)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </main>
  );
}

export default Workouts;
