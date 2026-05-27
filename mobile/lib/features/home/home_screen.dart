import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_theme.dart';
import '../auth/presentation/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text('home.greeting'.tr(namedArgs: {'name': user?.name ?? 'User'})),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${user?.credits ?? 0} ${'home.credits'.tr()}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authStateProvider.notifier).logout();
                context.go('/login');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'logout', child: Text('auth.logout'.tr())),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'home.no_topics'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'home.create_first'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.push('/upload'),
                icon: const Icon(Icons.add_photo_alternate),
                label: Text('home.upload_material'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
