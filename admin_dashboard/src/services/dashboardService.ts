import api from './api';

// Types for dashboard data
export interface DashboardStats {
  totalUsers: number;
  activeUsers: number;
  newSignUps: number;
  signUpChange: number;
  workoutCompletionRate: number;
  completionChange: number;
}

export interface DailyUser {
  day: string;
  users: number;
}

export interface WeeklyCompletion {
  week: string;
  completion: number;
}

// Dashboard API calls
export const dashboardService = {
  // Get dashboard statistics
  getStats: async (): Promise<DashboardStats> => {
    const response = await api.get<{ success: boolean; data: DashboardStats }>(
      '/admin/dashboard/stats'
    );
    return response.data;
  },

  // Get daily active users
  getDailyUsers: async (): Promise<DailyUser[]> => {
    const response = await api.get<{ success: boolean; data: DailyUser[] }>(
      '/admin/dashboard/daily-users'
    );
    return response.data;
  },

  // Get weekly completion data
  getWeeklyCompletion: async (): Promise<WeeklyCompletion[]> => {
    const response = await api.get<{ success: boolean; data: WeeklyCompletion[] }>(
      '/admin/dashboard/weekly-completion'
    );
    return response.data;
  },
};

export default dashboardService;
