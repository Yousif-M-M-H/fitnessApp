import { Router } from 'express';
import { calculateNutritionPlan, getMyNutritionPlan } from './nutrition.controller.js';
import { calculateNutritionSchema } from './nutrition.validation.js';
import validate from '../../middlewares/validation.middleware.js';
import { authentication } from '../auth/auth.middleware.js';

const nutritionRouter = Router();

// Protected route - calculate nutrition for authenticated user
nutritionRouter.post(
  '/calculate',
  authentication,
  validate(calculateNutritionSchema),
  calculateNutritionPlan
);

// Protected route - get authenticated user's nutrition plan
nutritionRouter.get(
  '/my-plan',
  authentication,
  getMyNutritionPlan
);

export default nutritionRouter;
