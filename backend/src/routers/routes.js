import { Router } from "express";
import authRoute from "../modules/auth/auth.routes.js";
import userRoute  from "../modules/user/user.route.js";
import workoutRoutes from "../modules/workout/workout.route.js";
import nutritionRouter from "../modules/nutrition/nutrition.routes.js";
import adminRouter from "../modules/admin/admin.routes.js";

const router = Router()
router.use('/auth', authRoute);
router.use('/workouts', workoutRoutes);
router.use('/users', userRoute);
router.use('/nutrition', nutritionRouter);
router.use('/admin', adminRouter);

export default router;