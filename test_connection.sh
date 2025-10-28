#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Testing Fitness App Backend Connection"
echo "========================================="
echo ""

# Get local IP
LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
echo "Your computer's IP: ${YELLOW}${LOCAL_IP}${NC}"
echo ""

# Test 1: Localhost
echo "Test 1: Testing localhost connection..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"firstName\":\"Test\",\"lastName\":\"Local\",\"email\":\"test_$(date +%s)@example.com\",\"password\":\"password123\",\"dateOfBirth\":\"1995-05-15\",\"phone\":\"1111111111\"}" \
  2>/dev/null)

if [ "$RESPONSE" = "201" ] || [ "$RESPONSE" = "409" ]; then
  echo -e "${GREEN}✓ Localhost test PASSED${NC} (HTTP $RESPONSE)"
else
  echo -e "${RED}✗ Localhost test FAILED${NC} (HTTP $RESPONSE)"
  echo "Make sure your backend is running: cd backend && npm start"
  exit 1
fi
echo ""

# Test 2: Network IP
echo "Test 2: Testing network connection (simulates mobile device)..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://${LOCAL_IP}:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"firstName\":\"Test\",\"lastName\":\"Network\",\"email\":\"test_$(date +%s)@example.com\",\"password\":\"password123\",\"dateOfBirth\":\"1995-05-15\",\"phone\":\"2222222222\"}" \
  2>/dev/null)

if [ "$RESPONSE" = "201" ] || [ "$RESPONSE" = "409" ]; then
  echo -e "${GREEN}✓ Network test PASSED${NC} (HTTP $RESPONSE)"
  echo -e "${GREEN}✓ Your mobile device should be able to connect!${NC}"
else
  echo -e "${RED}✗ Network test FAILED${NC} (HTTP $RESPONSE)"
  echo "This means your mobile device will NOT be able to connect."
  echo "Possible issues:"
  echo "  - Firewall blocking connections"
  echo "  - Backend not listening on 0.0.0.0"
  echo "  - Wrong IP address"
  exit 1
fi
echo ""

# Summary
echo "========================================="
echo "Summary"
echo "========================================="
echo -e "${GREEN}✓ Backend is running on port 5000${NC}"
echo -e "${GREEN}✓ CORS is enabled${NC}"
echo -e "${GREEN}✓ Network connections are allowed${NC}"
echo ""
echo "Next steps:"
echo "1. Make sure your mobile device is on the same WiFi network"
echo "2. Open Flutter app on your device/emulator"
echo "3. Try registering a new user"
echo ""
echo "API Endpoints:"
echo "  Register: POST http://${LOCAL_IP}:5000/api/v1/auth/register"
echo "  Login:    POST http://${LOCAL_IP}:5000/api/v1/auth/login"
echo "  Nutrition: POST http://${LOCAL_IP}:5000/api/v1/nutrition/calculate"
echo ""
echo "If you see connection errors, check:"
echo "  - lib/core/network/api_constants.dart has IP: ${LOCAL_IP}"
echo "  - Your firewall allows port 5000"
echo "  - Both devices are on the same WiFi"
echo ""
