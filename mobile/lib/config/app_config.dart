enum Flavor { dev, prod }

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool showDebugBanner;

  const AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.showDebugBanner,
  });

  static late AppConfig instance;

  static AppConfig dev() => const AppConfig._(
        flavor: Flavor.dev,
        appName: 'Vandix Dev',
        apiBaseUrl: 'http://10.0.2.2:8000',
        showDebugBanner: true,
      );

  static AppConfig prod() => const AppConfig._(
        flavor: Flavor.prod,
        appName: 'Vandix',
        apiBaseUrl: 'https://api.vandix.app',
        showDebugBanner: false,
      );

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;
}
