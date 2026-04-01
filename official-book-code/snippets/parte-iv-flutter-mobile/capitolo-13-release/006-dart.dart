class ApiConfig {
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static String get baseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.notes-app.example.com/api';
      case 'staging':
        return 'https://staging-api.notes-app.example.com/api';
      default:
        return 'http://10.0.2.2:3000/api';
    }
  }
}