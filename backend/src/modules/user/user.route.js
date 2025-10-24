import { Router } from "express";

import { authentication, authorize, checkActive, userExist } from "../auth/auth.middleware.js";
import validate from "../../middlewares/validation.middleware.js";
import { updateAdminSchema, updateUserSchema } from "./user.validation.js";
import { Role } from "../../utils/enum/roleEnum.js";
import { adminDeleteUser, deleteUser, getAllUsers, getProfile, getUserById, toggleUserStatus, updateProfile } from "./user.controller.js";

const router = Router();

router.get("/me", authentication,checkActive, getProfile);
router.put("/me", authentication, updateProfile);
router.delete("/me", authentication, deleteUser);

// Admin routes
router.get("/", authentication, authorize(Role.ADMIN), getAllUsers);
router.get("/:id", authentication, authorize(Role.ADMIN), getUserById);
router.delete("/:id", authentication, authorize(Role.ADMIN), adminDeleteUser);
router.patch("/:id/toggle-status", authentication, authorize(Role.ADMIN), toggleUserStatus);

export default router;