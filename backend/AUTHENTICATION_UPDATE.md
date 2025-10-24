# Authentication Update - User-Specific Features

## Changes Made

### Overview
Updated the nutrition calculator and workout customizer endpoints to **require authentication**. This ensures each user has their own personalized nutrition and workout plans that are saved to their profile.

---

## What Changed

### 1. Nutrition Calculator Endpoint
**Endpoint:** `POST /api/v1/nutrition/calculate`

**Before:**
- Authentication was optional
- Could be used without logging in
- Data was only saved if user was authenticated

**After:**
- Authentication is **required**
- User must provide JWT token in Authorization header
- Data is automatically saved to the user's profile
- Each user has their own nutrition plan

**Updated Files:**
- [src/modules/nutrition/nutrition.routes.js](src/modules/nutrition/nutrition.routes.js:10-15) - Added `authentication` middleware
- [src/modules/nutrition/nutrition.controller.js](src/modules/nutrition/nutrition.controller.js:5-40) - Removed optional check, always saves to user profile

---

### 2. Workout Customizer Endpoint
**Endpoint:** `POST /api/v1/workouts/customize`

**Before:**
- Authentication was optional
- Could be used without logging in
- Preferences were only saved if user was authenticated

**After:**
- Authentication is **required**
- User must provide JWT token in Authorization header
- Preferences are automatically saved to the user's profile
- Each user has their own workout preferences

**Updated Files:**
- [src/modules/workout/workout.route.js](src/modules/workout/workout.route.js:14) - Added `authentication` middleware
- [src/modules/workout/workout.controller.js](src/modules/workout/workout.controller.js:212-238) - Removed optional check, always saves to user profile

---

## How to Use in Flutter

### Step 1: User Registration
```dart
POST /api/v1/auth/register
Body: {
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "password123",
  "dateOfBirth": "1995-05-15",
  "phone": "1234567890"
}
```

### Step 2: User Login
```dart
POST /api/v1/auth/login
Body: {
  "email": "john@example.com",
  "password": "password123"
}

Response: {
  "message": "Login successful",
  "user": { ... },
  "token": "eyJhbGc..." // Save this token!
}
```

### Step 3: Store the Token
```dart
// Store the JWT token in secure storage
final prefs = await SharedPreferences.getInstance();
await prefs.setString('jwt_token', response['token']);
```

### Step 4: Use Token for Authenticated Requests

**Calculate Nutrition Plan:**
```dart
POST /api/v1/nutrition/calculate
Headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer YOUR_JWT_TOKEN"
}
Body: {
  "weight": 75,
  "height": 175,
  "age": 28,
  "gender": "male",
  "activityLevel": "moderate",
  "goal": "gain_muscle"
}
```

**Customize Workout Plan:**
```dart
POST /api/v1/workouts/customize
Headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer YOUR_JWT_TOKEN"
}
Body: {
  "gymDaysPerWeek": 5,
  "fitnessLevel": "intermediate",
  "gender": "male",
  "sessionDuration": "60-90min",
  "goal": "gain_muscle"
}
```

---

## Error Handling

### 401 Unauthorized
If the user is not authenticated or the token is invalid:
```json
{
  "statusMessage": "failed",
  "message": "Unauthorized",
  "code": 401
}
```

**Handle this in Flutter:**
- Redirect user to login screen
- Clear stored token
- Show "Please log in" message

### Token Expiration
JWT tokens expire after 7 days. If you get a 401 error:
1. Check if token exists
2. If expired, redirect to login
3. After successful login, retry the request

---

## Benefits

1. **User-Specific Data**: Each user has their own nutrition and workout plans
2. **Data Persistence**: Plans are saved to user profile and can be retrieved later
3. **Security**: Only authenticated users can create plans
4. **Profile Management**: Users can view their saved data via `GET /api/v1/users/me`

---

## Retrieve Saved Data

**Get User Profile (includes saved nutrition and workout data):**
```dart
GET /api/v1/users/me
Headers: {
  "Authorization": "Bearer YOUR_JWT_TOKEN"
}

Response: {
  "success": true,
  "data": {
    "_id": "...",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    // Nutrition data
    "weight": 75,
    "height": 175,
    "gender": "male",
    "dailyCalories": 2949,
    "proteinIntake": 221,
    "carbIntake": 332,
    "fatIntake": 82,
    "goal": "gain_muscle",
    "activityLevel": "moderate",
    // Workout data
    "gymDaysPerWeek": 5,
    "sessionDuration": "60-90min",
    ...
  }
}
```

**Get Saved Nutrition Plan:**
```dart
GET /api/v1/nutrition/my-plan
Headers: {
  "Authorization": "Bearer YOUR_JWT_TOKEN"
}
```

---

## Testing

All endpoints have been tested and verified to work correctly:

✅ Nutrition calculator requires authentication
✅ Workout customizer requires authentication
✅ Data is saved to user profile
✅ Data can be retrieved from user profile
✅ Proper error messages for unauthorized requests

---

## Documentation Updated

The [API_DOCUMENTATION.md](API_DOCUMENTATION.md) file has been updated to reflect these changes:
- Authentication requirements marked as "Required"
- Response messages updated
- curl examples updated with Authorization headers
- App flow updated to emphasize authentication requirement
