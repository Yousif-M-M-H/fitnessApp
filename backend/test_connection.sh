#!/bin/bash

echo "=================================="
echo "Network Connection Test Script"
echo "=================================="
echo ""

# Get current IP address
echo "📍 Current IP Address:"
IP_ADDRESS=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
echo "   $IP_ADDRESS"
echo ""

# Check if backend is running
echo "🔍 Checking if backend is running on port 5000..."
if lsof -i :5000 | grep -q LISTEN; then
    echo "   ✅ Backend is running!"
    lsof -i :5000 | grep LISTEN
else
    echo "   ❌ Backend is NOT running!"
    echo "   Please start the backend with: cd backend && npm start"
    exit 1
fi
echo ""

# Test localhost connection
echo "🔌 Testing localhost connection..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/v1/auth/login --max-time 5 2>&1)
if [ "$HTTP_CODE" = "400" ] || [ "$HTTP_CODE" = "401" ]; then
    echo "   ✅ Localhost connection works! (HTTP $HTTP_CODE)"
else
    echo "   ⚠️  Localhost response: $HTTP_CODE"
fi
echo ""

# Test IP connection
echo "🌐 Testing IP address connection..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$IP_ADDRESS:5000/api/v1/auth/login --max-time 5 2>&1)
if [ "$HTTP_CODE" = "400" ] || [ "$HTTP_CODE" = "401" ]; then
    echo "   ✅ IP address connection works! (HTTP $HTTP_CODE)"
else
    echo "   ❌ IP address connection failed!"
    echo "   HTTP Code: $HTTP_CODE"
fi
echo ""

# Check firewall status (macOS)
echo "🔥 Checking firewall status..."
if [ -f /usr/libexec/ApplicationFirewall/socketfilterfw ]; then
    FIREWALL_STATUS=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)
    echo "   $FIREWALL_STATUS"

    if echo "$FIREWALL_STATUS" | grep -q "enabled"; then
        echo ""
        echo "   ⚠️  Firewall is ENABLED - this might block connections"
        echo "   To allow connections:"
        echo "   1. System Preferences > Security & Privacy > Firewall"
        echo "   2. Click 'Firewall Options'"
        echo "   3. Add Node.js and allow incoming connections"
    fi
fi
echo ""

# Instructions
echo "=================================="
echo "📱 Instructions for Mobile Device:"
echo "=================================="
echo "1. Make sure mobile device is on SAME WiFi network"
echo "2. IP address already updated in Flutter app"
echo "3. Try this URL in mobile browser:"
echo "   http://$IP_ADDRESS:5000/api/v1/auth/login"
echo "4. If browser shows error 400/401, connection works!"
echo "5. Rebuild Flutter app: flutter run"
echo "=================================="
