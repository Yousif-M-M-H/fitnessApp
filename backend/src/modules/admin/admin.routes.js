import { Router } from "express";
import { getDashboardStats, getDailyActiveUsers, getWeeklyCompletion, getAllUsers, updateUser, deleteUser, getAllWorkouts } from "./admin.controller.js";

const router = Router();

// Dashboard routes - temporarily without auth for testing
router.get("/dashboard/stats", getDashboardStats);
router.get("/dashboard/daily-users", getDailyActiveUsers);
router.get("/dashboard/weekly-completion", getWeeklyCompletion);
router.get("/users", getAllUsers);
router.put("/users/:id", updateUser);
router.delete("/users/:id", deleteUser);
router.get("/workouts", getAllWorkouts);

export default router;
