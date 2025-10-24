import Joi from "joi";

export const updateUserSchema = Joi.object({
  name: Joi.string().min(2).max(50).optional(),
  email: Joi.string().email().optional(),
  phone: Joi.string()
    .pattern(/^[0-9]{6,12}$/) // من 6 إلى 12 رقم
    .messages({
      'string.pattern.base': 'Phone number must be between 6 and 12 digits',
    })
    .optional(),
});

export const updateAdminSchema = Joi.object({
  name: Joi.string().min(2).max(50).optional(),
  email: Joi.string().email().optional(),
  phone: Joi.string()
    .pattern(/^[0-9]{6,12}$/) 
    .messages({
      'string.pattern.base': 'Phone number must be between 6 and 12 digits',
    })
    .optional(),
  id: Joi.string().hex().length(24),
});
