import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'config/app_config.dart';
import 'shared/theme/app_theme.dart';
import 'router/app_router.dart';

void bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  AppConfig.instance = config;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(child: VandixApp(config: config)),
    ),
  );
}

class VandixApp extends ConsumerWidget {
  final AppConfig config;
  const VandixApp({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
