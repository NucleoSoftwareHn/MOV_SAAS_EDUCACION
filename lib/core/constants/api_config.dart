class ApiConfig {
  // Android Emulator -> use 10.0.2.2 instead of localhost.
  // iOS Simulator/Desktop -> localhost normally works.
  // Physical device -> use the IP address of the computer running Node.js.
  static const String baseUrl = 'http://localhost:3001/api/dev';

  static const String login = '/login';
}
