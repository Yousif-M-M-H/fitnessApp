import Joi from "joi";

export const createWorkoutPlanSchema = Joi.object({
  name: Joi.string().min(3).max(100).required(),
  description: Joi.string().min(10).max(500).required(),
  goal: Joi.string().valid("lose_weight", "gain_muscle", "fitness").required(),
  activityLevel: Joi.string()
    .valid("beginner", "intermediate", "advanced")
    .required(),

});

export const updateWorkoutPlanSchema = Joi.object({
  name: Joi.string().min(3).max(100),
  description: Joi.string().min(10).max(500),
  goal: Joi.string().valid("lose_weight", "gain_muscle", "fitness"),
  activityLevel: Joi.string().valid("beginner", "intermediate", "advanced"),
 id: Joi.string().hex().length(24).required(),
});

export const assignPlanSchema = Joi.object({
    userId: Joi.string().hex().length(24).required(),
    planId: Joi.string().hex().length(24).required(),
});

export const idWithParamsSchema = Joi.object({
    id: Joi.string().hex().length(24).required(),
});

export const customizeWorkoutSchema = Joi.object({
  gymDaysPerWeek: Joi.number().min(1).max(7).required().messages({
    'number.base': 'Gym days per week must be a number',
    'number.min': 'Gym days per week must be at least 1',
    'number.max': 'Gym days per week cannot exceed 7',
    'any.required': 'Gym days per week is required'
  }),
  fitnessLevel: Joi.string().valid('beginner', 'intermediate', 'advanced').required().messages({
    'string.base': 'Fitness level must be a string',
    'any.only': 'Fitness level must be "beginner", "intermediate", or "advanced"',
    'any.required': 'Fitness level is required'
  }),
  gender: Joi.string().valid('male', 'female').required().messages({
    'string.base': 'Gender must be a string',
    'any.only': 'Gender must be "male" or "female"',
    'any.required': 'Gender is required'
  }),
  sessionDuration: Joi.string().valid('30-45min', '45-60min', '60-90min').required().messages({
    'string.base': 'Session duration must be a string',
    'any.only': 'Session duration must be "30-45min", "45-60min", or "60-90min"',
    'any.required': 'Session duration is required'
  }),
  goal: Joi.string().valid('lose_weight', 'gain_muscle', 'fitness').optional()
});