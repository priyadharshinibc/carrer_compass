import { Router } from 'express';
import {
  createUserHandler,
  deleteUserHandler,
  getAllUsers,
  getUser,
  updateUserHandler,
} from '../controllers/userController.js';

const router = Router();

router.get('/', getAllUsers);
router.get('/:id', getUser);
router.post('/', createUserHandler);
router.put('/:id', updateUserHandler);
router.delete('/:id', deleteUserHandler);

export default router;
