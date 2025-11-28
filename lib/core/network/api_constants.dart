import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _port = '5000';
  static const String _apiVersion = 'api/v1';

  /// Automatically determines the correct base URL based on the platform
  static String get baseUrl {
    // IMPORTANT FOR DEPLOYMENT:
    // - Android Emulator: Use 10.0.2.2
    // - Physical Device: Use your computer's IP (e.g., 192.168.0.167)
    // - iOS Simulator: Use localhost

    if (kIsWeb) {
      return 'http://localhost:$_port/$_apiVersion';
    } else if (Platform.isAndroid) {
      // Android Emulator uses 10.0.2.2 to access host machine's localhost
      // FOR PHYSICAL DEVICE: Change to 'http://YOUR_IP_HERE:$_port/$_apiVersion'
      return 'http://10.0.2.2:$_port/$_apiVersion';
    } else if (Platform.isIOS) {
      // iOS Simulator can use localhost
      return 'http://localhost:$_port/$_apiVersion';
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
