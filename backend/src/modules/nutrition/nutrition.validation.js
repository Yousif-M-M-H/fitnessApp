import Joi from 'joi';

export const calculateNutritionSchema = Joi.object({
  weight: Joi.number().min(20).max(500).required().messages({
    'number.base': 'Weight must be a number',
    'number.min': 'Weight must be at least 20 kg',
    'number.max': 'Weight must not exceed 500 kg',
    'any.required': 'Weight is required'
  }),
  height: Joi.number().min(50).max(300).required().messages({
    'number.base': 'Height must be a number',
    'number.min': 'Height must be at least 50 cm',
    'number.max': 'Height must not exceed 300 cm',
    'any.required': 'Height is required'
  }),
  age: Joi.number().min(10).max(120).required().messages({
    'number.base': 'Age must be a number',
    'number.min': 'Age must be at least 10 years',
    'number.max': 'Age must not exceed 120 years',
    'any.required': 'Age is required'
  }),
  gender: Joi.string().valid('male', 'female').required().messages({
    'string.base': 'Gender must be a string',
    'any.only': 'Gender must be either "male" or "female"',
    'any.required': 'Gender is required'
  }),
  activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active').optional(),
  goal: Joi.string().valid('lose_weight', 'gain_muscle', 'maintain_weight', 'fitness').optional()
});
