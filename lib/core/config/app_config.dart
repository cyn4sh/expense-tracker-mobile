class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/',
  );

  static const String googleServerClientId =
      '351540960020-1dk27cvfem5ppjadsgg4uu7st4rsobjk.apps.googleusercontent.com';
}