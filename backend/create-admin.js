import bcrypt from 'bcrypt';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import User from './src/models/user.js';

// Load environment variables
dotenv.config({ path: ['.env.local', '.env'] });

// Connect to MongoDB
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.DB_URL);
    console.log('✅ Connected to MongoDB');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error);
    process.exit(1);
  }
};

// Create admin user
const createAdmin = async () => {
  try {
    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: 'admin@fittrack.com' });

    if (existingAdmin) {
      console.log('⚠️  Admin user already exists!');
      console.log('📧 Email: admin@fittrack.com');
      console.log('🔑 Password: admin123');
      return;
    }

    // Hash password
    const hashedPassword = bcrypt.hashSync('admin123', 10);

    // Create admin user
    const admin = await User.create({
      firstName: 'Admin',
      lastName: 'User',
      email: 'admin@fittrack.com',
      password: hashedPassword,
      phone: '1234567890',
      dateOfBirth: new Date('1990-01-01'),
      role: 'admin',
      isActive: true,
    });

    console.log('✅ Admin user created successfully!');
    console.log('📧 Email: admin@fittrack.com');
    console.log('🔑 Password: admin123');
    console.log('\n⚠️  Please change the password after first login!');
  } catch (error) {
    console.error('❌ Error creating admin:', error.message);
  } finally {
    await mongoose.connection.close();
    console.log('\n👋 Disconnected from MongoDB');
    process.exit(0);
  }
};

// Run
connectDB().then(createAdmin);
