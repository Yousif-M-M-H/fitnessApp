# Quick Start Guide 🚀

Get your fitness app backend up and running in minutes!

## Prerequisites

- Node.js (v18+)
- MongoDB (running on port 27017)
- npm or yarn

## Installation

```bash
# Navigate to backend directory
cd /home/yosif/Desktop/fitness_app/backend

# Install dependencies
npm install

# Start MongoDB (if not running)
sudo systemctl start mongod
# OR
mongod
```

## Running the Server

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

Server will start on: **http://localhost:5000**

## Test the API

### Quick Test Commands

```bash
# 1. Register a new user
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "password": "password123",
    "dateOfBirth": "1995-05-15"
  }'

# 2. Login
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'

# 3. Calculate Nutrition (no auth needed)
curl -X POST http://localhost:5000/api/v1/nutrition/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "weight": 75,
    "height": 175,
    "age": 28,
    "gender": "male",
    "activityLevel": "moderate",
    "goal": "gain_muscle"
  }'

# 4. Generate Workout Plan (no auth needed)
curl -X POST http://localhost:5000/api/v1/workouts/customize \
  -H "Content-Type: application/json" \
  -d '{
    "gymDaysPerWeek": 5,
    "fitnessLevel": "intermediate",
    "gender": "male",
    "sessionDuration": "60-90min",
    "goal": "gain_muscle"
  }'
```

## Main Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get JWT token
- `PUT /api/v1/auth/update-password` - Change password (auth required)

### Nutrition Calculator
- `POST /api/v1/nutrition/calculate` - Calculate nutrition plan
- `GET /api/v1/nutrition/my-plan` - Get saved plan (auth required)

### Workout Customizer
- `POST /api/v1/workouts/customize` - Generate custom workout plan
- `GET /api/v1/workouts/my-plans` - Get assigned plans (auth required)

### User Profile
- `GET /api/v1/users/me` - Get profile (auth required)
- `PUT /api/v1/users/me` - Update profile (auth required)
- `DELETE /api/v1/users/me` - Delete account (auth required)

## Environment Variables

Make sure your `.env` file contains:

```env
PORT=5000
HOST=http://localhost:5000
MONGO_URL=mongodb://127.0.0.1:27017/fitness
JWT_SECRET=e3de307a19a15fdc23ead35a127eb2b62f362ec0c2e1616ebfaaf1843b6803af
JWT_EXPIRES_IN=7d
MODE=development
```

## App Flow

```
1. User Registration
   ↓
2. User Login (receives JWT token)
   ↓
3. Choose Feature:

   A) Nutrition Calculator
      - Enter: weight, height, age, gender
      - Receive: daily calories, macros (protein, carbs, fat)
      - Values saved to profile if logged in

   B) Workout Customizer
      - Enter: gym days/week, fitness level, gender, session duration
      - Receive: personalized workout plan with exercises
      - Preferences saved to profile if logged in
```

## Example User Journey

```bash
# 1. Register
REGISTER=$(curl -s -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Sarah",
    "lastName": "Connor",
    "email": "sarah@example.com",
    "password": "terminator123",
    "dateOfBirth": "1990-08-29"
  }')

echo "✅ Registered: $(echo $REGISTER | jq -r '.user.email')"

# 2. Login
LOGIN=$(curl -s -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sarah@example.com",
    "password": "terminator123"
  }')

TOKEN=$(echo $LOGIN | jq -r '.token')
echo "✅ Logged in, token: ${TOKEN:0:50}..."

# 3. Calculate Nutrition
NUTRITION=$(curl -s -X POST http://localhost:5000/api/v1/nutrition/calculate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "weight": 65,
    "height": 168,
    "age": 34,
    "gender": "female",
    "activityLevel": "active",
    "goal": "lose_weight"
  }')

echo "✅ Nutrition calculated:"
echo $NUTRITION | jq '.data'

# 4. Generate Workout
WORKOUT=$(curl -s -X POST http://localhost:5000/api/v1/workouts/customize \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "gymDaysPerWeek": 4,
    "fitnessLevel": "beginner",
    "gender": "female",
    "sessionDuration": "45-60min",
    "goal": "lose_weight"
  }')

echo "✅ Workout plan generated:"
echo $WORKOUT | jq '.data.summary'

# 5. Get Profile (with saved data)
PROFILE=$(curl -s -X GET http://localhost:5000/api/v1/users/me \
  -H "Authorization: Bearer $TOKEN")

echo "✅ Profile with saved nutrition & workout preferences:"
echo $PROFILE | jq '{
  name: "\(.user.firstName) \(.user.lastName)",
  nutrition: {
    calories: .user.dailyCalories,
    protein: .user.proteinIntake,
    carbs: .user.carbIntake,
    fat: .user.fatIntake
  },
  workout: {
    days: .user.gymDaysPerWeek,
    level: .user.activityLevel,
    duration: .user.sessionDuration
  }
}'
```

## Documentation Files

- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Complete API reference
- **[FIXES_SUMMARY.md](FIXES_SUMMARY.md)** - List of all fixes and improvements
- **[TEST_RESULTS.md](TEST_RESULTS.md)** - Test results and validation
- **[QUICK_START.md](QUICK_START.md)** - This file

## Troubleshooting

### Server won't start
```bash
# Check if MongoDB is running
pgrep mongod

# If not, start it
sudo systemctl start mongod

# Check if port 5000 is available
lsof -i :5000
```

### "npm: command not found"
```bash
# If using nvm
source ~/.nvm/nvm.sh
nvm use node

# Then try again
npm start
```

### Database connection errors
```bash
# Check MongoDB status
sudo systemctl status mongod

# Check connection string in .env
cat .env | grep MONGO_URL
# Should be: mongodb://127.0.0.1:27017/fitness
```

### Can't login after registration
- Make sure you're using the correct email and password
- Check server logs for errors
- Verify the user was created: check MongoDB

## Features

✅ User registration with validation
✅ Secure password hashing (bcrypt)
✅ JWT authentication (7-day tokens)
✅ Nutrition calculator with BMR/TDEE formulas
✅ Personalized workout plan generator
✅ User profile management
✅ Role-based access control (user/admin)
✅ Comprehensive input validation
✅ Consistent error handling
✅ Public endpoints (no auth needed for calculators)

## Next Steps

1. **Test the API** - Use Postman or curl to test endpoints
2. **Build Frontend** - Connect React/Vue/Angular frontend
3. **Add Features** - Email verification, password reset, etc.
4. **Deploy** - Deploy to production (Heroku, AWS, etc.)

## Need Help?

- Check [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for detailed endpoint info
- Review [TEST_RESULTS.md](TEST_RESULTS.md) for working examples
- Check server logs for error messages

---

**Happy coding! 💪🏋️‍♂️**
