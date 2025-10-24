import { Router } from 'express';
import { addAdmin, Login, Register, updatePassword } from './auth.controller.js';
import { authentication, authorize, userExist } from './auth.middleware.js';
import { LoginSchema, RegisterAdminSchema, RegisterSchema, updatePasswordSchema } from './auth.validation.js';
import validate from '../../middlewares/validation.middleware.js';
import { Role } from '../../utils/enum/roleEnum.js';

const authRoute = Router();
authRoute.post('/register', userExist, validate(RegisterSchema), Register);
authRoute.post('/admin',authentication,authorize([Role.ADMIN]),validate(RegisterAdminSchema),userExist,addAdmin);
authRoute.post('/login', validate(LoginSchema), Login);
authRoute.put('/update-password',authentication,validate(updatePasswordSchema) ,updatePassword)
export default authRoute;
