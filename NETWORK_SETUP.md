# Network Setup Guide

## Problem
Your Flutter app works in Postman but not on emulator/physical device.

## Solution Applied

### 1. Updated API Configuration
**File:** `lib/core/network/api_constants.dart`

The app now automatically detects the platform and uses the correct URL:
- **Android Emulator**: `http://10.0.2.2:5000/api/v1`
- **iOS Simulator**: `http://localhost:5000/api/v1`
- **Physical Device**: `http://192.168.0.167:5000/api/v1` (your computer's IP)

### 2. Updated Backend Server
**File:** `backend/index.js`

The server now listens on `0.0.0.0` (all network interfaces) instead of just `localhost`, allowing connections from:
- Your computer (localhost)
- Emulators
- Physical devices on the same WiFi network

---

## How to Test

### Step 1: Start the Backend Server

```bash
cd backend
npm start
```

You should see:
```
server is running on port: 5000
Local: http://localhost:5000
Network: http://192.168.0.167:5000
Make sure your mobile device is on the same WiFi network!
```

### Step 2: Test on Different Platforms

#### A. Test on Android Emulator
```bash
flutter run
```
- The app will use: `http://10.0.2.2:5000/api/v1`
- This is the special Android emulator address for host machine

#### B. Test on iOS Simulator
```bash
flutter run
```
- The app will use: `http://localhost:5000/api/v1`
- iOS simulator can access localhost directly

#### C. Test on Physical Device
```bash
flutter run --release
```
- The app will use: `http://192.168.0.167:5000/api/v1`
- **IMPORTANT**: Your phone and computer MUST be on the same WiFi network

---

## Troubleshooting

### Issue 1: "Connection Refused" or "Network Error"

**Solution:**
1. Check that backend is running: `curl http://localhost:5000/api/v1/auth/register`
2. Check that backend is accessible on network: `curl http://192.168.0.167:5000/api/v1/auth/register`
3. Check firewall settings (allow port 5000)

### Issue 2: Physical Device Can't Connect

**Check your IP address:**
```bash
# macOS/Linux
ifconfig | grep inet

# Windows
ipconfig
```

**Update the IP in:** `lib/core/network/api_constants.dart` (line 10)
```dart
static const String _localIpAddress = 'YOUR_IP_HERE';
```

### Issue 3: Different WiFi Networks

**Problem:** Your computer is on WiFi, but your phone is on mobile data.

**Solution:** Connect both to the same WiFi network.

### Issue 4: Firewall Blocking Connections

**macOS:**
```bash
# Temporarily allow all incoming connections
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off

# Or add Node.js to allowed apps
System Preferences > Security & Privacy > Firewall > Firewall Options
```

**Windows:**
```
Control Panel > Windows Firewall > Allow an app through firewall
Add: Node.js
```

---

## Testing Endpoints

### Register User
```bash
POST http://192.168.0.167:5000/api/v1/auth/register
Content-Type: application/json

{
  "firstName": "Test",
  "lastName": "User",
  "email": "test@example.com",
  "password": "password123",
  "dateOfBirth": "1995-05-15",
  "phone": "1234567890"
}
```

### Test from Terminal
```bash
# Test from your computer
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Test","lastName":"User","email":"test@example.com","password":"password123","dateOfBirth":"1995-05-15","phone":"1234567890"}'

# Test from network (simulates phone)
curl -X POST http://192.168.0.167:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Test","lastName":"User","email":"test2@example.com","password":"password123","dateOfBirth":"1995-05-15","phone":"1234567891"}'
```

---

## Debug Mode

The app will print network configuration on startup:

```
🌐 API Configuration:
📍 Base URL: http://10.0.2.2:5000/api/v1
📱 Platform: android
🔧 Debug Mode: true

⚠️  If the app cannot connect to the backend:
1. Find your computer's IP address
2. Update _localIpAddress in lib/core/network/api_constants.dart
3. Ensure your device and computer are on the same WiFi network
4. Check that your backend server is running on port 5000
```

---

## Production Deployment

When deploying to production:
1. Replace `http://192.168.0.167:5000` with your production API URL
2. Use environment variables or build flavors
3. Enable HTTPS
4. Update CORS settings to restrict origins

---

## Quick Checklist

- [ ] Backend server is running on port 5000
- [ ] Backend shows "Network: http://192.168.0.167:5000" on startup
- [ ] Computer and phone are on the same WiFi network
- [ ] Firewall allows connections on port 5000
- [ ] IP address in `api_constants.dart` matches your computer's IP
- [ ] CORS is enabled in backend (already done)

---

**Your current IP:** `192.168.0.167`
**Backend port:** `5000`
**API Base URL:** `http://192.168.0.167:5000/api/v1`
