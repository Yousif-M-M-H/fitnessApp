import cors from 'cors';
import express from 'express';
import dotenv from 'dotenv';
import helmet from 'helmet';
import morgan from 'morgan';
import { db_connect } from './src/config/database.js';
import v1Router from './src/routers/routes.js';

// app
const app = express();

// dotenv config
dotenv.config({
 path: ['.env.local', '.env']
});

// database connect
db_connect();

// middlewares
app.use(express.json());
app.use(helmet());
app.use(cors());
app.use(morgan(process.env.MODE === 'development' ? 'dev' : 'combined'));

app.use('/api/v1', v1Router);
app.use('/uploads', express.static('uploads'))

// Global error handler
app.use((error, req, res, next) => {
    const statusCode = error.statusCode || 500;  
    const statusMessage = error.statusMessage || 'failed'; 
    
    return res.status(statusCode).json({
      statusMessage: statusMessage,
      message: error.message || 'An error occurred', 
      code: statusCode,
      stack: process.env.MOOD === 'development' ? error.stack : undefined 
    });
  });

// server
const port = process.env.PORT || 5001;
app.listen(port, () => console.log(`server is runing on port: ${port}`));
