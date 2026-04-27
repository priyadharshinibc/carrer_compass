import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

import usersRouter from './routes/users.js';
import { errorHandler, notFoundHandler } from './middleware/errorHandler.js';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '1mb' }));

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/users', usersRouter);
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
