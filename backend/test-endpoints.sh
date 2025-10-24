#!/bin/bash

# Fitness App Backend Test Script
# This script tests the main endpoints

BASE_URL="http://localhost:5000/api/v1"

echo "================================"
echo "Fitness App Backend API Tests"
echo "================================"
echo ""

# Test 1: Nutrition Calculator (Public)
echo "Test 1: Nutrition Calculator (Public)"
echo "--------------------------------------"
curl -X POST "$BASE_URL/nutrition/calculate" \
  -H "Content-Type: application/json" \
  -d '{
    "weight": 75,
    "height": 175,
    "age": 28,
    "gender": "male",
    "activityLevel": "moderate",
    "goal": "gain_muscle"
  }' | jq '.'
echo ""
echo ""

# Test 2: Workout Customizer (Public)
echo "Test 2: Workout Customizer (Public)"
echo "------------------------------------"
curl -X POST "$BASE_URL/workouts/customize" \
  -H "Content-Type: application/json" \
  -d '{
    "gymDaysPerWeek": 5,
    "fitnessLevel": "intermediate",
    "gender": "male",
    "sessionDuration": "60-90min",
    "goal": "gain_muscle"
  }' | jq '.data.summary, .data.recommendations'
echo ""
echo ""

# Test 3: User Registration
echo "Test 3: User Registration"
echo "-------------------------"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "testuser'$(date +%s)'@example.com",
    "password": "password123",
    "dateOfBirth": "1995-05-15"
  }')
echo "$REGISTER_RESPONSE" | jq '.'
echo ""
echo ""

# Test 4: User Login
echo "Test 4: User Login with registered credentials"
echo "----------------------------------------------"
REGISTERED_EMAIL=$(echo "$REGISTER_RESPONSE" | jq -r '.user.email')
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$REGISTERED_EMAIL\",
    \"password\": \"password123\"
  }")
echo "$LOGIN_RESPONSE" | jq '.'

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
echo ""
echo "JWT Token obtained: ${TOKEN:0:50}..."
echo ""
echo ""

# Test 5: Get User Profile (Authenticated)
echo "Test 5: Get User Profile (Authenticated)"
echo "----------------------------------------"
curl -X GET "$BASE_URL/users/me" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""
echo ""

# Test 6: Calculate Nutrition (Authenticated - saves to profile)
echo "Test 6: Calculate Nutrition (Authenticated)"
echo "-------------------------------------------"
curl -X POST "$BASE_URL/nutrition/calculate" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "weight": 75,
    "height": 175,
    "age": 28,
    "gender": "male",
    "activityLevel": "moderate",
    "goal": "gain_muscle"
  }' | jq '.'
echo ""
echo ""

# Test 7: Get Saved Nutrition Plan
echo "Test 7: Get Saved Nutrition Plan"
echo "---------------------------------"
curl -X GET "$BASE_URL/nutrition/my-plan" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""
echo ""

echo "================================"
echo "All tests completed!"
echo "================================"
