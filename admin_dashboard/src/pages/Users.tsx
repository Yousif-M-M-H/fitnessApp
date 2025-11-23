import { Search, ChevronLeft, ChevronRight, Trash2 } from 'lucide-react';
import { useState, useEffect } from 'react';

interface User {
  _id: string;
  firstName: string;
  lastName: string;
  email: string;
  createdAt: string;
}

function Users() {
  const [allUsers, setAllUsers] = useState<User[]>([]);
  const [activeUsers, setActiveUsers] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const usersPerPage = 10;

  useEffect(() => {
    fetchUsers();
    fetchActiveUsers();
  }, []);

  const fetchUsers = () => {
    // Fetch users from backend
    fetch('http://localhost:5000/api/v1/admin/users')
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          setAllUsers(data.data);
        }
      })
      .catch(err => console.error('Failed to fetch users:', err));
  };

  const fetchActiveUsers = () => {
    // Fetch active users count
    fetch('http://localhost:5000/api/v1/admin/dashboard/stats')
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          setActiveUsers(data.data.activeUsers);
        }
      })
      .catch(err => console.error('Failed to fetch active users:', err));
  };

  const handleDelete = (userId: string, userName: string) => {
    if (window.confirm(`Are you sure you want to delete ${userName}?`)) {
      fetch(`http://localhost:5000/api/v1/admin/users/${userId}`, {
        method: 'DELETE',
      })
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            // Remove user from state
            setAllUsers(prev => prev.filter(user => user._id !== userId));
            alert('User deleted successfully');
          } else {
            alert(data.message || 'Failed to delete user');
          }
        })
        .catch(err => {
          console.error('Failed to delete user:', err);
          alert('Failed to delete user');
        });
    }
  };

  // Filter users based on search query
  const filteredUsers = allUsers.filter(user => {
    const fullName = `${user.firstName} ${user.lastName}`.toLowerCase();
    const email = user.email.toLowerCase();
    const query = searchQuery.toLowerCase();
    return fullName.includes(query) || email.includes(query);
  });

  // Pagination logic
  const totalPages = Math.ceil(filteredUsers.length / usersPerPage);
  const startIndex = (currentPage - 1) * usersPerPage;
  const endIndex = startIndex + usersPerPage;
  const currentUsers = filteredUsers.slice(startIndex, endIndex);

  // Reset to page 1 when search changes
  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery]);

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  };

  return (
    <main className="main-content">
      <h1>Users Management</h1>

      {/* Active Users Card */}
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
            Active Users
          </div>
          <div style={{ fontSize: '42px', fontWeight: '700', color: '#10b981' }}>
            {activeUsers}
          </div>
        </div>
        <div style={{ fontSize: '14px', color: '#9ca3af' }}>
          Total: {allUsers.length} users
        </div>
      </div>

      {/* Search */}
      <div style={{ marginBottom: '24px' }}>
        <div className="search-box">
          <Search size={20} />
          <input
            type="text"
            placeholder="Search users by name or email"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
      </div>

      {/* Users Table */}
      <div className="table-container">
        <table className="users-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Joined Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {currentUsers.map((user) => (
              <tr key={user._id}>
                <td>
                  <div className="user-info">
                    <div className="user-avatar">
                      {user.firstName.charAt(0)}
                    </div>
                    <div className="user-details">
                      <div className="user-name">{user.firstName} {user.lastName}</div>
                    </div>
                  </div>
                </td>
                <td>{user.email}</td>
                <td>{formatDate(user.createdAt)}</td>
                <td>
                  <button
                    className="action-button"
                    onClick={() => handleDelete(user._id, `${user.firstName} ${user.lastName}`)}
                    title="Delete user"
                  >
                    <Trash2 size={20} />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="pagination" style={{ marginTop: '24px' }}>
          <button
            className="pagination-button"
            onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
            disabled={currentPage === 1}
          >
            <ChevronLeft size={20} />
          </button>

          {[...Array(totalPages)].map((_, i) => {
            const page = i + 1;
            // Show first page, last page, current page, and pages around current
            if (
              page === 1 ||
              page === totalPages ||
              (page >= currentPage - 1 && page <= currentPage + 1)
            ) {
              return (
                <button
                  key={page}
                  className={`pagination-button ${currentPage === page ? 'active' : ''}`}
                  onClick={() => setCurrentPage(page)}
                >
                  {page}
                </button>
              );
            } else if (page === currentPage - 2 || page === currentPage + 2) {
              return <span key={page} className="pagination-dots">...</span>;
            }
            return null;
          })}

          <button
            className="pagination-button"
            onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
            disabled={currentPage === totalPages}
          >
            <ChevronRight size={20} />
          </button>
        </div>
      )}
    </main>
  );
}

export default Users;
