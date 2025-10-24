
import { Router } from "express";

import { authentication, authorize } from "../auth/auth.middleware.js";
import { assignAutoPlanToUser, assignPlanToUser, createWorkoutPlan, customizeWorkoutPlan, deleteWorkoutPlan, getUserPlans, getWorkoutPlanById, getWorkoutPlans, updateWorkoutPlan } from "./workout.controller.js";
import { Role } from "../../utils/enum/roleEnum.js";
import validate from "../../middlewares/validation.middleware.js";
import { assignPlanSchema, createWorkoutPlanSchema, customizeWorkoutSchema, idWithParamsSchema, updateWorkoutPlanSchema } from "./workout.validation.js";
import { uploadSingleFile } from "../../middlewares/upload.middleware.js";

const router = Router();

router.post("/", authentication, authorize(Role.ADMIN),uploadSingleFile("fileUrl"),validate(createWorkoutPlanSchema), createWorkoutPlan);     // Create
router.post("/customize", authentication, validate(customizeWorkoutSchema), customizeWorkoutPlan); // Customize workout plan (requires auth)
router.get("/my-plans", authentication, getUserPlans); // Get plans for logged-in user
router.get("/all",authentication, authorize(Role.ADMIN), getWorkoutPlans);         // Read all
router.get("/:id",authentication,validate(idWithParamsSchema), getWorkoutPlanById);   // Read one
router.put("/:id",authentication, authorize(Role.ADMIN),uploadSingleFile("fileUrl"),validate(updateWorkoutPlanSchema), updateWorkoutPlan);    // Update
router.delete("/:id",authentication, authorize(Role.ADMIN),validate(idWithParamsSchema), deleteWorkoutPlan); // Delete
router.post("/assign-plan", authentication, authorize(Role.ADMIN),validate(assignPlanSchema), assignPlanToUser); // Assign plan to user
router.post("/assign-auto-plan", authentication,authorize(Role.USER), assignAutoPlanToUser);
export default router;
