import jwt from 'jsonwebtoken';
import User from '../../models/user.js';
import { AppError, asyncHandler } from '../../utils/error/error.js';
export const userExist = asyncHandler(async (req, res, next) => {
  const { email, phone } = req.body;

  // Check if email exists
  const emailExists = await User.findOne({ email });
  if (emailExists) {
    return next(new AppError('This email is already taken', 409));
  }

  // Check if phone exists
  const phoneExists = await User.findOne({ phone });
  if (phoneExists) {
    return next(new AppError('This phone number is already taken', 409));
  }

  next();
});

export const authentication = (req, res, next) => {
  const token = req.headers.authorization;

  if (!token || !token.startsWith('Bearer')) throw new AppError('Unauthorized', 401);

  const bearerToken = token.split(' ')[1];

  try {
    const decoded = jwt.verify(bearerToken, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN,
    });
    req.user = decoded;
    next();
  } catch (error) {
    throw new AppError(error.message, 498);
  }
};

export const authorize = roles => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      throw new AppError('Forbidden', 403);
    }
    next();
  };
};

export const checkActive = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return next(new AppError("User not found", 404));
    }

    if (!user.isActive) {
        return next(new AppError("Your account has been suspended. Please contact support.", 403));
    }

    next();
  } catch (error) {
    next(error);
  }
};