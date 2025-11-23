import { useState, useEffect } from 'react';
import { LineChart, Line, XAxis, ResponsiveContainer } from 'recharts';

function Dashboard() {
  const [activeUsers, setActiveUsers] = useState(892);
  const [workoutCompletionRate, setWorkoutCompletionRate] = useState(68);
  const [completionChange, setCompletionChange] = useState(5);

  useEffect(() => {
    // Fetch stats from backend
    fetch('http://localhost:5000/api/v1/admin/dashboard/stats')
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          setActiveUsers(data.data.activeUsers);
          setWorkoutCompletionRate(data.data.workoutCompletionRate);
          setCompletionChange(data.data.completionChange);
        }
      })
      .catch(err => console.error('Failed to fetch stats:', err));
  }, []);

  // Dummy data for everything else
  const stats = {
    totalUsers: 1247,
    activeUsers: activeUsers,
    newSignUps: 156,
    signUpChange: 12,
    workoutCompletionRate: workoutCompletionRate,
    completionChange: completionChange
  };

  const dailyUsers = [
    { day: 'Mon', users: 245 },
    { day: 'Tue', users: 312 },
    { day: 'Wed', users: 278 },
    { day: 'Thu', users: 356 },
    { day: 'Fri', users: 398 },
    { day: 'Sat', users: 425 },
    { day: 'Sun', users: 389 }
  ];

  const weeklyCompletion = [
    { week: 'Week 1', completion: 58 },
    { week: 'Week 2', completion: 62 },
    { week: 'Week 3', completion: 65 },
    { week: 'Week 4', completion: 68 }
  ];

  // Calculate current daily average from the data
  const currentDailyAverage = Math.round(
    dailyUsers.reduce((sum, day) => sum + day.users, 0) / dailyUsers.length
  );

  // Get current week's completion rate
  const currentWeekCompletion = weeklyCompletion[weeklyCompletion.length - 1].completion;

  // Calculate weekly completion change
  const weeklyCompletionChange =
    weeklyCompletion[weeklyCompletion.length - 1].completion -
    weeklyCompletion[weeklyCompletion.length - 2].completion;

  return (
    <main className="main-content">
      <h1>Dashboard</h1>

      {/* Stats Grid */}
      <div className="stats-grid">
        <div className="stat-card">
          <h3>Active Users</h3>
          <div className="value">{stats.activeUsers.toLocaleString()}</div>
          <div className="change positive">
            Total: {stats.totalUsers.toLocaleString()} users
          </div>
        </div>
        <div className="stat-card">
          <h3>Workout Completion</h3>
          <div className="value">{stats.workoutCompletionRate}%</div>
          <div className={`change ${stats.completionChange >= 0 ? 'positive' : 'negative'}`}>
            {stats.completionChange >= 0 ? '+' : ''}{stats.completionChange}% from last month
          </div>
        </div>
        <div className="stat-card">
          <h3>New Sign-Ups</h3>
          <div className="value">{stats.newSignUps.toLocaleString()}</div>
          <div className={`change ${stats.signUpChange >= 0 ? 'positive' : 'negative'}`}>
            {stats.signUpChange >= 0 ? '+' : ''}{stats.signUpChange}% from last month
          </div>
        </div>
      </div>

      {/* User Engagement Section */}
      <section className="user-engagement">
        <h2>User Engagement</h2>
        <div className="engagement-grid">
          {/* Daily Active Users Chart */}
          <div className="engagement-card">
            <div className="engagement-card-header">
              <h3>Daily Active Users</h3>
              <span className="change">Last 7 days</span>
            </div>
            <div className="value">{currentDailyAverage}</div>
            <div className="chart-container">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={dailyUsers}>
                  <XAxis
                    dataKey="day"
                    stroke="#9ca3af"
                    style={{ fontSize: '12px' }}
                  />
                  <Line
                    type="monotone"
                    dataKey="users"
                    stroke="#10b981"
                    strokeWidth={3}
                    dot={false}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Workout Completion by Week */}
          <div className="engagement-card">
            <div className="engagement-card-header">
              <h3>Workout Completion by Week</h3>
              <span className={`change ${weeklyCompletionChange >= 0 ? 'positive' : 'negative'}`}>
                {weeklyCompletionChange >= 0 ? '+' : ''}{weeklyCompletionChange}%
              </span>
            </div>
            <div className="value">{currentWeekCompletion}%</div>
            <div className="week-bars">
              {weeklyCompletion.map((week) => (
                <div key={week.week} className="week-bar">
                  <div
                    className="bar"
                    style={{ height: `${week.completion * 2}px` }}
                  />
                  <span className="week-label">{week.week}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}

export default Dashboard;
