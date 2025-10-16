class ApiConstants {
  // Use the appropriate URL based on your testing environment:
  // - Android Emulator: Use 'http://10.0.2.2:5000/api/v1'
  // - iOS Simulator: Use 'http://localhost:5000/api/v1' or your Mac's IP
  // - Physical Device: Use your computer's IP address (e.g., 'http://192.168.1.x:5000/api/v1')
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
