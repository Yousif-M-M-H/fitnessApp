import { Users, Dumbbell, Settings, MessageSquare, HelpCircle } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

function Sidebar() {
  const location = useLocation();

  const navItems = [
    { path: '/', icon: Users, label: 'Users' },
    { path: '/workouts', icon: Dumbbell, label: 'Workouts' },
    { path: '/settings', icon: Settings, label: 'Settings' },
  ];

  return (
    <aside className="sidebar">
      <div className="logo">
        <div className="logo-icon">💪</div>
        <span>FitTrack Pro</span>
      </div>
      <nav className="nav">
        {navItems.map((item) => {
          const Icon = item.icon;
          return (
            <Link
              key={item.path}
              to={item.path}
              className={`nav-item ${location.pathname === item.path ? 'active' : ''}`}
            >
              <Icon size={20} />
              <span>{item.label}</span>
            </Link>
          );
        })}
      </nav>
      <div className="sidebar-footer">
        <div className="nav-item">
          <MessageSquare size={20} />
          <span>Feedback</span>
        </div>
        <div className="nav-item">
          <HelpCircle size={20} />
          <span>Help</span>
        </div>
      </div>
    </aside>
  );
}

export default Sidebar;
