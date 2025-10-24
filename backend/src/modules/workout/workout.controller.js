
import WorkoutPlan from "../../models/workout.js";
import { AppError, asyncHandler } from "../../utils/error/error.js";
import path from 'path';
import fs from 'fs';
import User from "../../models/user.js";
import { generateWorkoutPlan } from './workout.service.js';

// Create workout plan
export const createWorkoutPlan = asyncHandler(async (req, res, next) => {
  

  if (!req.file) {
    return next(new AppError("Workout plan file is required", 400));
  }

  // Check if a plan with the same name already exists
  const existingPlan = await WorkoutPlan.findOne({ name: req.body.name });
  if (existingPlan) {
    return next(new AppError("A workout plan with this name already exists", 409));
  }
  

  const plan = await WorkoutPlan.create({
    ...req.body,
    fileUrl: req.file.filename,
  });

  res.status(201).json({
    success: true,
    data: plan,
    message: "Workout plan created successfully",
  });
});

// Get all workout plans
export const getWorkoutPlans = asyncHandler(async (req, res, next) => {
  const workouts = await WorkoutPlan.find();

  res.status(200).json({
    success: true,
    count: workouts.length,
    data: workouts,
  });
});

// Get single workout plan by id
export const getWorkoutPlanById = asyncHandler(async (req, res, next) => {
  const workout = await WorkoutPlan.findById(req.params.id);

  if (!workout) {
    return next(new AppError("Workout plan not found", 404));
  }

  res.status(200).json({
    success: true,
    data: workout,
  });
});

// Update workout plan
export const updateWorkoutPlan = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const { name, description, goal, activityLevel } = req.body;

  const plan = await WorkoutPlan.findById(id);

  if (!plan) {
    return next(new AppError("Workout plan not found", 404));
  }

  const updateData = {};

  if (name) updateData.name = name;
  if (description) updateData.description = description;
  if (goal) updateData.goal = goal;
  if (activityLevel) updateData.activityLevel = activityLevel;

  if (req.file) {
    const oldFilePath = path.join(process.cwd(), "uploads", plan.fileUrl);
    if (fs.existsSync(oldFilePath)) {
      fs.unlinkSync(oldFilePath);
    }

    updateData.fileUrl = req.file.filename;
  }

  const updatedPlan = await WorkoutPlan.findByIdAndUpdate(id, updateData, {
    new: true,
    runValidators: true,
  });

  res.status(200).json({
    success: true,
    data: updatedPlan,
    message: "Workout plan updated successfully",
  });
});


// Delete workout plan
export const deleteWorkoutPlan = asyncHandler(async (req, res, next) => {
  const { id } = req.params;

  const plan = await WorkoutPlan.findById(id);

  if (!plan) {
    return next(new AppError("Workout plan not found", 404));
  }


  const filePath = path.join(process.cwd(), "uploads", plan.fileUrl);
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  }

  await WorkoutPlan.findByIdAndDelete(id);

  res.status(200).json({
    success: true,
    message: "Workout plan deleted successfully",
  });
});


// Get workout plans for a specific user
export const getUserPlans = asyncHandler(async (req, res, next) => {
  
  const user = await User.findById(req.user.id).populate("workoutPlans");

  if (!user) {
    return next(new AppError("User not found", 404));
  }

  res.status(200).json({
    success: true,
    count: user.workoutPlans.length,
    data: user.workoutPlans,
  });
});

// Assign workout plan to user
export const assignPlanToUser = asyncHandler(async (req, res, next) => {
  const { userId, planId } = req.body;

  const user = await User.findById(userId);
  if (!user) {
    return next(new AppError("User not found", 404));
  }


  const plan = await WorkoutPlan.findById(planId);
  if (!plan) {
    return next(new AppError("Workout plan not found", 404));
  }


  if (user.workoutPlans.includes(planId)) {
    return next(new AppError("Plan already assigned to this user", 400));
  }
  
  user.workoutPlans.push(planId);
  await user.save();

  res.status(200).json({
    success: true,
    message: "Plan assigned successfully",
    data: user,
  });
});


// Auto assign workout plan based on user profile
export const assignAutoPlanToUser = asyncHandler(async (req, res, next) => {
  const userId = req.user.id;
  const user = await User.findById(userId);

  if (!user) {
    return next(new AppError("User not found", 404));
  }


  const plan = await WorkoutPlan.findOne({
    goal: user.goal,
    activityLevel: user.activityLevel,
  });

  if (!plan) {
    return next(new AppError("No suitable workout plan found", 404));
  }

  if (user.workoutPlans.includes(plan._id)) {
    return res.status(200).json({
      success: true,
      message: "User already has this workout plan",
      data: user,
    });
  }


  user.workoutPlans.push(plan._id);
  await user.save();

  res.status(200).json({
    success: true,
    message: "Workout plan assigned successfully",
    data: user,
  });
});

// Customize workout plan based on user inputs
export const customizeWorkoutPlan = asyncHandler(async (req, res, next) => {
  const { gymDaysPerWeek, fitnessLevel, gender, sessionDuration, goal } = req.body;

  // Generate customized workout plan
  const workoutPlan = generateWorkoutPlan({
    gymDaysPerWeek,
    fitnessLevel,
    gender,
    sessionDuration,
    goal: goal || 'fitness'
  });

  // Save preferences to user's profile
  await User.findByIdAndUpdate(req.user.id, {
    gymDaysPerWeek,
    activityLevel: fitnessLevel,
    gender,
    sessionDuration,
    goal: goal || 'fitness'
  });

  res.status(200).json({
    success: true,
    message: 'Workout plan customized and saved successfully',
    data: workoutPlan
  });
});