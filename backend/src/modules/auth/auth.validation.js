import Joi from 'joi';

export const RegisterSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  dateOfBirth: Joi.date().max('now').required(),
  phone: Joi.string().pattern(/^[0-9]{8,15}$/).optional(),
});

export const LoginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

export const updatePasswordSchema = Joi.object({
  oldPassword:Joi.string().min(5).required(),
  newPassword :Joi.string().min(5).required(),
})

export const RegisterAdminSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  phone: Joi.string().pattern(/^[0-9]{8,15}$/).optional(),
  role: Joi.string().valid("admin").required(),
});