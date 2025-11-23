import { asyncHandler } from "../../utils/error/error.js";
import User from "../../models/user.js";
import UserWorkout from "../../models/userWorkout.js";

// Get dashboard statistics
export const getDashboardStats = asyncHandler(async (req, res) => {
  // Get total users count
  const totalUsers = await User.countDocuments({ role: "user" });

  // Get active users count
  const activeUsers = await User.countDocuments({ role: "user", isActive: true });

  // Get new sign-ups in the last 30 days
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const newSignUps = await User.countDocuments({
    role: "user",
    createdAt: { $gte: thirtyDaysAgo }
  });

  // Get new sign-ups from 60-30 days ago for comparison
  const sixtyDaysAgo = new Date();
  sixtyDaysAgo.setDate(sixtyDaysAgo.getDate() - 60);

  const previousMonthSignUps = await User.countDocuments({
    role: "user",
    createdAt: { $gte: sixtyDaysAgo, $lt: thirtyDaysAgo }
  });

  // Calculate percentage change for sign-ups
  const signUpChange = previousMonthSignUps > 0
    ? Math.round(((newSignUps - previousMonthSignUps) / previousMonthSignUps) * 100)
    : 0;

  // Get users with workout plans (workout completion rate)
  const usersWithPlans = await User.countDocuments({
    role: "user",
    workoutPlans: { $exists: true, $ne: [] }
  });

  const workoutCompletionRate = totalUsers > 0
    ? Math.round((usersWithPlans / totalUsers) * 100)
    : 0;

  // Calculate previous month's completion rate for comparison
  const previousMonthUsers = await User.countDocuments({
    role: "user",
    createdAt: { $lt: thirtyDaysAgo }
  });

  const previousUsersWithPlans = await User.countDocuments({
    role: "user",
    createdAt: { $lt: thirtyDaysAgo },
    workoutPlans: { $exists: true, $ne: [] }
  });

  const previousCompletionRate = previousMonthUsers > 0
    ? Math.round((previousUsersWithPlans / previousMonthUsers) * 100)
    : 0;

  const completionChange = previousCompletionRate > 0
    ? workoutCompletionRate - previousCompletionRate
    : 0;

  res.status(200).json({
    success: true,
    data: {
      totalUsers,
      activeUsers,
      newSignUps,
      signUpChange,
      workoutCompletionRate,
      completionChange
    }
  });
});

// Get daily active users for the last 7 days
export const getDailyActiveUsers = asyncHandler(async (req, res) => {
  const dailyData = [];
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Get data for the last 7 days
  for (let i = 6; i >= 0; i--) {
    const date = new Date();
    date.setDate(date.getDate() - i);
    date.setHours(0, 0, 0, 0);

    const nextDate = new Date(date);
    nextDate.setDate(nextDate.getDate() + 1);

    // Count users who logged in on this day (using updatedAt as a proxy for activity)
    const activeCount = await User.countDocuments({
      role: "user",
      updatedAt: { $gte: date, $lt: nextDate }
    });

    dailyData.push({
      day: days[date.getDay()],
      users: activeCount
    });
  }

  res.status(200).json({
    success: true,
    data: dailyData
  });
});

// Get weekly workout completion data for the last 4 weeks
export const getWeeklyCompletion = asyncHandler(async (req, res) => {
  const weeklyData = [];

  for (let i = 3; i >= 0; i--) {
    const weekStart = new Date();
    weekStart.setDate(weekStart.getDate() - (i * 7 + 7));
    weekStart.setHours(0, 0, 0, 0);

    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekEnd.getDate() + 7);

    // Get users who created accounts before this week
    const usersBeforeWeek = await User.countDocuments({
      role: "user",
      createdAt: { $lt: weekEnd }
    });

    // Get users with workout plans during this week
    const usersWithPlansThisWeek = await User.countDocuments({
      role: "user",
      createdAt: { $lt: weekEnd },
      workoutPlans: { $exists: true, $ne: [] }
    });

    const completion = usersBeforeWeek > 0
      ? Math.round((usersWithPlansThisWeek / usersBeforeWeek) * 100)
      : 0;

    weeklyData.push({
      week: `Week ${4 - i}`,
      completion
    });
  }

  res.status(200).json({
    success: true,
    data: weeklyData
  });
});

// Get all users
export const getAllUsers = asyncHandler(async (req, res) => {
  const users = await User.find({ role: "user" })
    .select('firstName lastName email createdAt')
    .sort({ createdAt: -1 });

  res.status(200).json({
    success: true,
    data: users
  });
});

// Delete a user
export const deleteUser = asyncHandler(async (req, res) => {
  const { id } = req.params;

  const user = await User.findById(id);

  if (!user) {
    return res.status(404).json({
      success: false,
      message: 'User not found'
    });
  }

  if (user.role === 'admin') {
    return res.status(403).json({
      success: false,
      message: 'Cannot delete admin users'
    });
  }

  await User.findByIdAndDelete(id);

  res.status(200).json({
    success: true,
    message: 'User deleted successfully'
  });
});

// Get all workouts
export const getAllWorkouts = asyncHandler(async (req, res) => {
  const workouts = await UserWorkout.find()
    .select('userName workoutSplit goal fitnessLevel gymDaysPerWeek sessionDuration createdAt')
    .sort({ createdAt: -1 });

  res.status(200).json({
    success: true,
    data: workouts
  });
});
