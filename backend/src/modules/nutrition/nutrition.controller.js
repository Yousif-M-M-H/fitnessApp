import { asyncHandler, AppError } from '../../utils/error/error.js';
import User from '../../models/user.js';
import { calculateNutrition } from './nutrition.service.js';

/**
 * Calculate nutrition plan for authenticated user
 * POST /api/v1/nutrition/calculate
 * Requires authentication
 */
export const calculateNutritionPlan = asyncHandler(async (req, res) => {
  const { weight, height, age, gender, activityLevel, goal } = req.body;

  // Calculate nutrition values
  const nutritionData = calculateNutrition({
    weight,
    height,
    age,
    gender,
    activityLevel: activityLevel || 'moderate',
    goal: goal || 'fitness'
  });

  // Save the nutrition data to user's profile
  await User.findByIdAndUpdate(req.user.id, {
    weight,
    height,
    gender,
    dailyCalories: nutritionData.dailyCalories,
    proteinIntake: nutritionData.proteinIntake,
    carbIntake: nutritionData.carbIntake,
    fatIntake: nutritionData.fatIntake,
    goal: goal || 'fitness',
    activityLevel: activityLevel || 'moderate'
  });

  res.status(200).json({
    message: 'Nutrition plan calculated and saved successfully',
    data: nutritionData
  });
});

/**
 * Get user's saved nutrition plan
 * GET /api/v1/nutrition/my-plan
 */
export const getMyNutritionPlan = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user.id).select(
    'dailyCalories proteinIntake carbIntake fatIntake weight height goal activityLevel'
  );

  if (!user.dailyCalories) {
    throw new AppError('No nutrition plan found. Please calculate your nutrition plan first.', 404);
  }

  res.status(200).json({
    message: 'Nutrition plan retrieved successfully',
    data: {
      dailyCalories: user.dailyCalories,
      proteinIntake: user.proteinIntake,
      carbIntake: user.carbIntake,
      fatIntake: user.fatIntake,
      weight: user.weight,
      height: user.height,
      goal: user.goal,
      activityLevel: user.activityLevel
    }
  });
});
