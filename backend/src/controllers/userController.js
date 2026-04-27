import { createUserSchema, updateUserSchema } from '../validators/userValidator.js';
import { createUser, deleteUser, getUserById, listUsers, updateUser } from '../services/userService.js';

function sendValidationError(res, error) {
  return res.status(400).json({
    message: 'Validation failed',
    errors: error.flatten(),
  });
}

export async function getAllUsers(req, res, next) {
  try {
    const users = await listUsers();
    res.json({ data: users });
  } catch (error) {
    next(error);
  }
}

export async function getUser(req, res, next) {
  try {
    const user = await getUserById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ data: user });
  } catch (error) {
    next(error);
  }
}

export async function createUserHandler(req, res, next) {
  try {
    const parsed = createUserSchema.safeParse(req.body);
    if (!parsed.success) {
      return sendValidationError(res, parsed.error);
    }

    const user = await createUser(parsed.data);
    res.status(201).json({ data: user });
  } catch (error) {
    next(error);
  }
}

export async function updateUserHandler(req, res, next) {
  try {
    const parsed = updateUserSchema.safeParse(req.body);
    if (!parsed.success) {
      return sendValidationError(res, parsed.error);
    }

    const user = await updateUser(req.params.id, parsed.data);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ data: user });
  } catch (error) {
    next(error);
  }
}

export async function deleteUserHandler(req, res, next) {
  try {
    const deleted = await deleteUser(req.params.id);
    if (!deleted) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(204).send();
  } catch (error) {
    next(error);
  }
}
