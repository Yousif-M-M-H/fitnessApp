# Fitness App Backend API Documentation

## Base URL
```
http://localhost:5000/api/v1
```

---

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 1. User Registration & Authentication

### Register User
**Endpoint:** `POST /auth/register`

**Description:** Register a new user with email, password, and personal information.

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "password": "password123",
  "dateOfBirth": "1995-05-15",
  "phone": "1234567890"
}
```

**Note:** Gender, height, and weight are optional at signup. They can be provided later when using the nutrition calculator or updating the profile.

**Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "_id": "65f1234567890abcdef",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "dateOfBirth": "1995-05-15T00:00:00.000Z",
    "phone": "1234567890",
    "role": "user",
    "isActive": true,
    "workoutPlans": [],
    "createdAt": "2025-10-15T19:30:00.000Z",
    "updatedAt": "2025-10-15T19:30:00.000Z"
  }
}
```

**Validation Rules:**
- `firstName`: 2-50 characters, required
- `lastName`: 2-50 characters, required
- `email`: Valid email format, required, unique
- `password`: Minimum 6 characters, required
- `dateOfBirth`: Valid date (not in future), required
- `phone`: 8-15 digits, optional

---

### Login
**Endpoint:** `POST /auth/login`

**Description:** Login with email and password to receive JWT token.

**Request Body:**
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "message": "Login successful",
  "user": {
    "_id": "65f1234567890abcdef",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "role": "user",
    "isActive": true
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses:**
- 401: Invalid email or password
- 403: Account suspended

---

### Update Password
**Endpoint:** `PUT /auth/update-password`

**Authentication:** Required

**Request Body:**
```json
{
  "oldPassword": "password123",
  "newPassword": "newPassword456"
}
```

**Response (200 OK):**
```json
{
  "message": "Password updated successfully"
}
```

---

## 2. Nutrition Calculator

### Calculate Nutrition Plan
**Endpoint:** `POST /nutrition/calculate`

**Description:** Calculate daily caloric needs and macronutrient distribution based on user metrics.

**Authentication:** Required (saves to user's profile)

**Request Body:**
```json
{
  "weight": 75,
  "height": 175,
  "age": 28,
  "gender": "male",
  "activityLevel": "moderate",
  "goal": "gain_muscle"
}
```

**Parameters:**
- `weight`: Weight in kg (20-500), required
- `height`: Height in cm (50-300), required
- `age`: Age in years (10-120), required
- `gender`: "male" or "female", required
- `activityLevel`: "sedentary", "light", "moderate", "active", "very_active" (optional, default: "moderate")
- `goal`: "lose_weight", "gain_muscle", "fitness" (optional, default: "fitness")

**Response (200 OK):**
```json
{
  "message": "Nutrition plan calculated and saved successfully",
  "data": {
    "dailyCalories": 2755,
    "proteinIntake": 206,
    "carbIntake": 310,
    "fatIntake": 77,
    "bmr": 1782,
    "tdee": 2761
  }
}
```

**Calculation Methods:**
- **BMR (Basal Metabolic Rate):** Mifflin-St Jeor Equation
  - Male: 10 × weight + 6.25 × height - 5 × age + 5
  - Female: 10 × weight + 6.25 × height - 5 × age - 161

- **TDEE (Total Daily Energy Expenditure):** BMR × Activity Multiplier
  - Sedentary: BMR × 1.2
  - Light: BMR × 1.375
  - Moderate: BMR × 1.55
  - Active: BMR × 1.725
  - Very Active: BMR × 1.9

- **Daily Calories:**
  - Lose Weight: TDEE - 500
  - Gain Muscle: TDEE + 300
  - Fitness: TDEE

- **Macros (based on goal):**
  - Lose Weight: 35% protein, 35% carbs, 30% fat
  - Gain Muscle: 30% protein, 45% carbs, 25% fat
  - Fitness: 30% protein, 40% carbs, 30% fat

---

### Get My Nutrition Plan
**Endpoint:** `GET /nutrition/my-plan`

**Authentication:** Required

**Description:** Retrieve the authenticated user's saved nutrition plan.

**Response (200 OK):**
```json
{
  "message": "Nutrition plan retrieved successfully",
  "data": {
    "dailyCalories": 2755,
    "proteinIntake": 206,
    "carbIntake": 310,
    "fatIntake": 77,
    "weight": 75,
    "height": 175,
    "goal": "gain_muscle",
    "activityLevel": "moderate"
  }
}
```

**Error Response:**
- 404: No nutrition plan found (user hasn't calculated yet)

---

## 3. Workout Plan Customizer

### Customize Workout Plan
**Endpoint:** `POST /workouts/customize`

**Description:** Generate a customized workout plan based on user preferences and goals.

**Authentication:** Required (saves preferences to user's profile)

**Request Body:**
```json
{
  "gymDaysPerWeek": 5,
  "fitnessLevel": "intermediate",
  "gender": "male",
  "sessionDuration": "60-90min",
  "goal": "gain_muscle"
}
```

**Parameters:**
- `gymDaysPerWeek`: Number of gym days per week (1-7), required
- `fitnessLevel`: "beginner", "intermediate", "advanced", required
- `gender`: "male" or "female", required
- `sessionDuration`: "30-45min", "45-60min", "60-90min", required
- `goal`: "lose_weight", "gain_muscle", "fitness" (optional, default: "fitness")

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Workout plan customized and saved successfully",
  "data": {
    "summary": {
      "gymDaysPerWeek": 5,
      "fitnessLevel": "intermediate",
      "gender": "male",
      "sessionDuration": "60-90min",
      "goal": "gain_muscle",
      "workoutSplit": "Push, Pull, Legs, Upper Body, Lower Body"
    },
    "weeklyPlan": [
      {
        "day": 1,
        "type": "Push",
        "duration": "60-90min",
        "exercises": [
          "Bench Press - 4x8-10",
          "Incline Dumbbell Press - 3x10",
          "Overhead Press - 4x8",
          "Tricep Pushdowns - 3x12",
          "Lateral Raises - 3x12",
          "Cable Flyes - 3x12"
        ]
      },
      {
        "day": 2,
        "type": "Pull",
        "duration": "60-90min",
        "exercises": [
          "Pull-ups - 4x6-10",
          "Barbell Rows - 4x8",
          "Lat Pulldowns - 3x10",
          "Dumbbell Rows - 3x10 each",
          "Barbell Curls - 3x10",
          "Hammer Curls - 3x12",
          "Rear Delt Flyes - 3x15"
        ]
      },
      {
        "day": 3,
        "type": "Legs",
        "duration": "60-90min",
        "exercises": [
          "Barbell Squats - 4x8-10",
          "Romanian Deadlifts - 4x10",
          "Leg Press - 3x12",
          "Leg Curls - 3x12",
          "Bulgarian Split Squats - 3x10 each",
          "Calf Raises - 4x15"
        ]
      },
      {
        "day": 4,
        "type": "Upper Body",
        "duration": "60-90min",
        "exercises": [
          "Bench Press - 4x8",
          "Barbell Rows - 4x8",
          "Overhead Press - 4x8",
          "Pull-ups - 3x8-10",
          "Dips - 3x10",
          "Barbell Curls - 3x10",
          "Skull Crushers - 3x10"
        ]
      },
      {
        "day": 5,
        "type": "Lower Body",
        "duration": "60-90min",
        "exercises": [
          "Barbell Squats - 4x8-10",
          "Romanian Deadlifts - 4x10",
          "Leg Press - 3x12",
          "Walking Lunges - 3x12 each",
          "Leg Curls - 3x12",
          "Calf Raises - 4x15"
        ]
      }
    ],
    "recommendations": {
      "cardio": "Limit cardio to 10-15 minutes of light activity for warm-up",
      "restDays": "Take 1-2 rest days per week. Consider active recovery like yoga or light cardio.",
      "nutrition": [
        "Eat in a slight caloric surplus",
        "Consume 1.2-1.5g protein per lb bodyweight",
        "Time carbs around workouts",
        "Get 7-9 hours of sleep for recovery"
      ],
      "progression": "Track your weights and aim to increase load or reps each week. Consider deload weeks every 4-6 weeks."
    },
    "generalTips": [
      "Always warm up for 5-10 minutes before training",
      "Focus on progressive overload - increase weight, reps, or volume over time",
      "Rest 2-3 minutes between heavy compound lifts, 60-90 seconds for accessories",
      "Track your workouts to monitor progress",
      "Listen to your body and take extra rest if needed"
    ]
  }
}
```

---

## 4. User Profile Management

### Get My Profile
**Endpoint:** `GET /users/me`

**Authentication:** Required

**Response (200 OK):**
```json
{
  "success": true,
  "user": {
    "_id": "65f1234567890abcdef",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "dateOfBirth": "1995-05-15T00:00:00.000Z",
    "gender": "male",
    "weight": 75,
    "height": 175,
    "dailyCalories": 2755,
    "proteinIntake": 206,
    "carbIntake": 310,
    "fatIntake": 77,
    "goal": "gain_muscle",
    "activityLevel": "intermediate",
    "gymDaysPerWeek": 5,
    "sessionDuration": "60-90min",
    "isActive": true,
    "workoutPlans": []
  }
}
```

---

### Update My Profile
**Endpoint:** `PUT /users/me`

**Authentication:** Required

**Request Body:** (all fields optional)
```json
{
  "firstName": "John",
  "lastName": "Doe Updated",
  "phone": "9876543210",
  "weight": 78,
  "height": 175
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": { /* updated user object */ }
}
```

---

### Delete My Account
**Endpoint:** `DELETE /users/me`

**Authentication:** Required

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

---

## 5. Workout Plan Management (Admin)

### Create Workout Plan (Admin)
**Endpoint:** `POST /workouts/`

**Authentication:** Required (Admin only)

**Content-Type:** `multipart/form-data`

**Request Body:**
```
name: "Beginner Full Body Program"
description: "A comprehensive full body workout for beginners"
goal: "fitness"
activityLevel: "beginner"
fileUrl: [Excel file upload]
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "_id": "65f9876543210abcdef",
    "name": "Beginner Full Body Program",
    "description": "A comprehensive full body workout for beginners",
    "goal": "fitness",
    "activityLevel": "beginner",
    "fileUrl": "uuid-filename.xlsx"
  },
  "message": "Workout plan created successfully"
}
```

---

### Get All Workout Plans (Admin)
**Endpoint:** `GET /workouts/all`

**Authentication:** Required (Admin only)

**Response (200 OK):**
```json
{
  "success": true,
  "count": 12,
  "data": [
    {
      "_id": "65f9876543210abcdef",
      "name": "Beginner Full Body Program",
      "description": "A comprehensive full body workout for beginners",
      "goal": "fitness",
      "activityLevel": "beginner",
      "fileUrl": "uuid-filename.xlsx"
    }
    // ... more plans
  ]
}
```

---

### Get My Workout Plans
**Endpoint:** `GET /workouts/my-plans`

**Authentication:** Required

**Description:** Get workout plans assigned to the authenticated user.

**Response (200 OK):**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "_id": "65f9876543210abcdef",
      "name": "Intermediate Push Pull Legs",
      "description": "A 6-day PPL split for intermediate lifters",
      "goal": "gain_muscle",
      "activityLevel": "intermediate",
      "fileUrl": "uuid-filename.xlsx"
    }
  ]
}
```

---

### Assign Plan to User (Admin)
**Endpoint:** `POST /workouts/assign-plan`

**Authentication:** Required (Admin only)

**Request Body:**
```json
{
  "userId": "65f1234567890abcdef",
  "planId": "65f9876543210abcdef"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Plan assigned successfully",
  "data": { /* user object with updated workoutPlans */ }
}
```

---

### Auto-Assign Workout Plan
**Endpoint:** `POST /workouts/assign-auto-plan`

**Authentication:** Required (User only)

**Description:** Automatically assign a workout plan that matches the user's goal and activity level.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Workout plan assigned successfully",
  "data": { /* user object with updated workoutPlans */ }
}
```

**Error Response:**
- 404: No suitable workout plan found matching user's profile

---

## Error Responses

All endpoints follow a consistent error response format:

**400 Bad Request:**
```json
{
  "message": "Weight must be at least 20 kg",
  "code": 400
}
```

**401 Unauthorized:**
```json
{
  "message": "Unauthorized",
  "code": 401
}
```

**403 Forbidden:**
```json
{
  "message": "Forbidden",
  "code": 403
}
```

**404 Not Found:**
```json
{
  "message": "User not found",
  "code": 404
}
```

**409 Conflict:**
```json
{
  "message": "This email is already taken",
  "code": 409
}
```

**500 Internal Server Error:**
```json
{
  "message": "Internal server error",
  "code": 500
}
```

---

## Testing Examples with curl

### Register a User
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "password": "password123",
    "dateOfBirth": "1995-05-15"
  }'
```

### Login
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```

### Calculate Nutrition (With Auth)
```bash
curl -X POST http://localhost:5000/api/v1/nutrition/calculate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "weight": 75,
    "height": 175,
    "age": 28,
    "gender": "male",
    "activityLevel": "moderate",
    "goal": "gain_muscle"
  }'
```

### Customize Workout (With Auth)
```bash
curl -X POST http://localhost:5000/api/v1/workouts/customize \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "gymDaysPerWeek": 5,
    "fitnessLevel": "intermediate",
    "gender": "male",
    "sessionDuration": "60-90min",
    "goal": "gain_muscle"
  }'
```

### Get My Profile (With Auth)
```bash
curl -X GET http://localhost:5000/api/v1/users/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## App Flow Summary

1. **User Sign-Up**: User registers with email, password, firstName, lastName, and dateOfBirth
2. **User Login**: User logs in and receives JWT token (required for all features)
3. **Choose Feature** (Authentication Required):
   - **Option A - Nutrition Calculator**:
     - User must be logged in with valid JWT token
     - User provides weight, height, age, gender
     - System calculates dailyCalories, proteinIntake, carbIntake, fatIntake
     - Values are automatically saved to user's profile
   - **Option B - Workout Customizer**:
     - User must be logged in with valid JWT token
     - User provides gymDaysPerWeek, fitnessLevel, gender, sessionDuration
     - System generates personalized workout plan with exercises, splits, and recommendations
     - Preferences are automatically saved to user's profile

---

## Notes

- Password is hashed using bcrypt (salt rounds: 10)
- JWT tokens expire after 7 days
- All dates should be in ISO 8601 format
- File uploads are limited to Excel files (.xls, .xlsx) with max size 10MB
- Uploaded files are stored in `/uploads` directory
- Static files available at `http://localhost:5000/uploads/filename`

---

## Database Models

### User Schema
- firstName, lastName, email, password (required)
- dateOfBirth, gender (required for regular users)
- weight, height, age (optional, needed for nutrition)
- dailyCalories, proteinIntake, carbIntake, fatIntake (calculated)
- goal, activityLevel, gymDaysPerWeek, sessionDuration (preferences)
- role (user/admin), isActive, workoutPlans (array of ObjectId)
- timestamps (createdAt, updatedAt)

### WorkoutPlan Schema
- name, description
- goal (lose_weight, gain_muscle, fitness)
- activityLevel (beginner, intermediate, advanced)
- fileUrl (Excel file reference)
- timestamps (createdAt, updatedAt)

---

## Environment Variables Required

```env
PORT=5000
HOST=http://localhost:5000
MONGO_URL=mongodb://127.0.0.1:27017/fitness
JWT_SECRET=your_secret_key_here
JWT_EXPIRES_IN=7d
MODE=development
```
