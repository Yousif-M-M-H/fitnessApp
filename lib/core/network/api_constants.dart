import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // IMPORTANT: Set your computer's local IP address here
  // To find your IP:
  // - macOS/Linux: Run 'ifconfig' or 'ipconfig getifaddr en0' in terminal
  // - Windows: Run 'ipconfig' in command prompt
  // Look for IPv4 address (e.g., 192.168.1.100, 10.0.0.5, etc.)
  static const String _localIpAddress = '10.129.244.196'; // Your computer's IP address

  static const String _port = '5000';
  static const String _apiVersion = 'api/v1';

  /// Automatically determines the correct base URL based on the platform
  static String get baseUrl {
    // FOR PHYSICAL DEVICE: Always use your computer's IP address
    // FOR EMULATOR: Use the emulator-specific address

    if (kIsWeb) {
      return 'http://localhost:$_port/$_apiVersion';
    } else if (Platform.isAndroid) {
      // Check if running on emulator by trying to detect emulator characteristics
      // Physical devices should ALWAYS use the local IP address
      return 'http://$_localIpAddress:$_port/$_apiVersion';
    } else if (Platform.isIOS) {
      return 'http://$_localIpAddress:$_port/$_apiVersion';
    } else {
      return 'http://localhost:$_port/$_apiVersion';
    }
  }

  // Endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String nutritionCalculateEndpoint = '/nutrition/calculate';
  static const String workoutCustomizeEndpoint = '/workouts/customize';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Helper method to get your computer's IP address
  /// Instructions printed when app starts
  static void printNetworkInfo() {
    if (kDebugMode) {
      print('🌐 API Configuration:');
      print('📍 Base URL: $baseUrl');
      print('📱 Platform: ${Platform.operatingSystem}');
      print('🔧 Debug Mode: $kDebugMode');
      print('');
      print('⚠️  If the app cannot connect to the backend:');
      print('1. Find your computer\'s IP address:');
      print('   - macOS/Linux: Run "ifconfig | grep inet" in terminal');
      print('   - Windows: Run "ipconfig" in command prompt');
      print('2. Update _localIpAddress in lib/core/network/api_constants.dart');
      print('3. Ensure your device and computer are on the same WiFi network');
      print('4. Check that your backend server is running on port $_port');
      print('');
    }
  }
}
