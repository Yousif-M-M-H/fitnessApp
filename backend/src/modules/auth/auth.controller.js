import bcrypt from 'bcrypt';
import User from '../../models/user.js';
import jwt from 'jsonwebtoken';
import { AppError, asyncHandler } from '../../utils/error/error.js';

export const Register = asyncHandler(async (req, res) => {
  if (req.body?.password) {
    req.body.password = bcrypt.hashSync(req.body.password, 10);
  }
  const user = await User.create(req.body);

  // Return user data without password
  const userResponse = user.toJSON();
  delete userResponse.password;

  res.status(201).json({
    message: 'User registered successfully',
    user: userResponse,
  });
});

export const addAdmin = asyncHandler(async (req, res) => {

  if (req.body?.password) {
    req.body.password = bcrypt.hashSync(req.body.password, 10);
  }
  await User.create(req.body);

  res.status(201).json({
    message: 'Created new admin successfully',
  });
});

export const Login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });

  if (!user || !bcrypt.compareSync(password, user.password)) {
    throw new AppError('Invalid email or password', 401);
  }

  // Check if user account is active
  if (!user.isActive) {
    throw new AppError('Your account has been suspended. Please contact support.', 403);
  }

  const { role, _id: id, name } = user;
  const token = jwt.sign({ id, role, name }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });

  // Return user data without password
  const userResponse = user.toJSON();
  delete userResponse.password;

  res.status(200).json({
    message: 'Login successful',
    user: userResponse,
    token,
  });
});



export const updatePassword = asyncHandler(async (req, res, next) => {
  const userId = req.user.id;
  const { oldPassword, newPassword } = req.body;

  if (!oldPassword || !newPassword) {
    return next(new AppError('Old password and new password are required', 400));
  }

  const user = await User.findById(userId);
  if (!user) {
    return next(new AppError('User not found', 404));
  }

  const isMatch = bcrypt.compareSync(oldPassword, user.password);
  if (!isMatch) {
    return next(new AppError('Old password is incorrect', 401));
  }

  user.password = bcrypt.hashSync(newPassword, 10);
  await user.save();

  res.status(200).json({
    message: 'Password updated successfully',
  });
});


