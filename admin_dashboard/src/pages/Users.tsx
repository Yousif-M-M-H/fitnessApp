import { Search, ChevronLeft, ChevronRight, Trash2, Edit2, X } from 'lucide-react';
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

  // Edit modal state
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [editForm, setEditForm] = useState({ firstName: '', lastName: '' });

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

  const handleEdit = (user: User) => {
    setEditingUser(user);
    setEditForm({ firstName: user.firstName, lastName: user.lastName });
    setIsEditModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsEditModalOpen(false);
    setEditingUser(null);
    setEditForm({ firstName: '', lastName: '' });
  };

  const handleSaveEdit = () => {
    if (!editingUser) return;

    if (!editForm.firstName.trim() || !editForm.lastName.trim()) {
      alert('First name and last name cannot be empty');
      return;
    }

    fetch(`http://localhost:5000/api/v1/admin/users/${editingUser._id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(editForm),
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          // Update user in state
          setAllUsers(prev => prev.map(user =>
            user._id === editingUser._id ? { ...user, ...editForm } : user
          ));
          alert('User updated successfully');
          handleCloseModal();
        } else {
          alert(data.message || 'Failed to update user');
        }
      })
      .catch(err => {
        console.error('Failed to update user:', err);
        alert('Failed to update user');
      });
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
                  <div style={{ display: 'flex', gap: '8px' }}>
                    <button
                      className="action-button"
                      onClick={() => handleEdit(user)}
                      title="Edit user"
                      style={{ color: '#3b82f6' }}
                    >
                      <Edit2 size={20} />
                    </button>
                    <button
                      className="action-button"
                      onClick={() => handleDelete(user._id, `${user.firstName} ${user.lastName}`)}
                      title="Delete user"
                      style={{ color: '#ef4444' }}
                    >
                      <Trash2 size={20} />
                    </button>
                  </div>
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

      {/* Edit Modal */}
      {isEditModalOpen && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.7)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000
        }}>
          <div style={{
            background: '#1a1f28',
            borderRadius: '12px',
            padding: '32px',
            width: '90%',
            maxWidth: '500px',
            position: 'relative'
          }}>
            <button
              onClick={handleCloseModal}
              style={{
                position: 'absolute',
                top: '16px',
                right: '16px',
                background: 'none',
                border: 'none',
                color: '#9ca3af',
                cursor: 'pointer',
                padding: '4px'
              }}
            >
              <X size={24} />
            </button>

            <h2 style={{ marginBottom: '24px', color: '#fff', fontSize: '24px' }}>
              Edit User
            </h2>

            <div style={{ marginBottom: '20px' }}>
              <label style={{ display: 'block', marginBottom: '8px', color: '#9ca3af', fontSize: '14px' }}>
                First Name
              </label>
              <input
                type="text"
                value={editForm.firstName}
                onChange={(e) => setEditForm({ ...editForm, firstName: e.target.value })}
                style={{
                  width: '100%',
                  padding: '12px',
                  borderRadius: '8px',
                  border: '1px solid #2d3748',
                  background: '#0f1419',
                  color: '#fff',
                  fontSize: '16px'
                }}
              />
            </div>

            <div style={{ marginBottom: '32px' }}>
              <label style={{ display: 'block', marginBottom: '8px', color: '#9ca3af', fontSize: '14px' }}>
                Last Name
              </label>
              <input
                type="text"
                value={editForm.lastName}
                onChange={(e) => setEditForm({ ...editForm, lastName: e.target.value })}
                style={{
                  width: '100%',
                  padding: '12px',
                  borderRadius: '8px',
                  border: '1px solid #2d3748',
                  background: '#0f1419',
                  color: '#fff',
                  fontSize: '16px'
                }}
              />
            </div>

            <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
              <button
                onClick={handleCloseModal}
                style={{
                  padding: '12px 24px',
                  borderRadius: '8px',
                  border: '1px solid #2d3748',
                  background: 'transparent',
                  color: '#9ca3af',
                  cursor: 'pointer',
                  fontSize: '14px',
                  fontWeight: '600'
                }}
              >
                Cancel
              </button>
              <button
                onClick={handleSaveEdit}
                style={{
                  padding: '12px 24px',
                  borderRadius: '8px',
                  border: 'none',
                  background: '#10b981',
                  color: '#0a0e14',
                  cursor: 'pointer',
                  fontSize: '14px',
                  fontWeight: '600'
                }}
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}

export default Users;
