import { asyncHandler, AppError } from "../../utils/error/error.js";
import User from "../../models/user.js";

// Update user data
export const updateProfile = asyncHandler(async (req, res, next) => {
  const userId = req.user.id;
  const { name, email, phone, height, weight, age, goal, activityLevel } = req.body;

  const updateData = { name, email, phone, height, weight, age, goal, activityLevel };

  const updatedUser = await User.findByIdAndUpdate(userId, updateData, {
    new: true,
    runValidators: true,
  });

  if (!updatedUser) {
    return next(new AppError("User not found", 404));
  }

  res.status(200).json({
    success: true,
    data: updatedUser,
    message: "Profile updated successfully",
  });
});

// Delete user account
export const deleteUser = asyncHandler(async (req, res, next) => {
    const userId = req.user.id;

    const deletedUser = await User.findByIdAndDelete(userId);

    if (!deletedUser) {
        return next(new AppError("User not found", 404));
    }

    res.status(200).json({ success: true, message: "User account deleted successfully" });
});

// Delete user admin only
export const adminDeleteUser = asyncHandler(async (req, res, next) => {
    const {id} = req.params

    const deletedUser = await User.findByIdAndDelete(id);

    if (!deletedUser) {
        return next(new AppError("User not found", 404));
    }

    res.status(200).json({ success: true, message: "User account deleted successfully" });
});

// Toggle user active status (admin only)
export const toggleUserStatus = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.params.id);

  if (!user) {
    return next(new AppError("User not found", 404));
  }

  user.isActive = !user.isActive;
  await user.save();

  res.status(200).json({
    success: true,
    data: user,
    message: `User is now ${user.isActive ? "active" : "inactive"}`,
  });
});

// Get user by ID
export const getUserById = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.params.id).populate("workoutPlans").select("-password");

  if (!user) {
    return next(new AppError("User not found", 404));
  }

  res.status(200).json({
    success: true,
    data: user,
  });
});

// Get all users
export const getAllUsers = asyncHandler(async (req, res) => {
  const users = await User.find().populate("workoutPlans", "name goal activityLevel").select("-password");
  res.status(200).json({
    success: true,
    data: users,
  });
})

// Get logged-in user's profile
export const getProfile = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user.id).populate("workoutPlans");

  res.status(200).json({
    success: true,
    data: user,
  });
});