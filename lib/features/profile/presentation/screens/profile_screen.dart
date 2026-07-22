import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/providers/categories_provider.dart';
import '../../../expenses/providers/expenses_provider.dart';
import '../../../budgets/providers/budgets_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../auth/presentation/screens/auth_gate.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/profile_provider.dart';
import '../../providers/email_verified_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            100,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            ref.watch(emailVerifiedProvider).maybeWhen(
              data: (verified) => verified
                  ? const SizedBox.shrink()
                  : Card(
                      color: theme.colorScheme.errorContainer,
                      child: const ListTile(
                        leading: Icon(Icons.warning_amber_rounded),
                        title: Text('Please verify your email'),
                        subtitle: Text('Check your inbox for a verification link.'),
                      ),
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark mode'),
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              onChanged: (_) =>
                  ref.read(themeModeProvider.notifier).toggle(),
            ),
            ref.watch(notificationPrefsProvider).when(
              data: (enabled) => SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                value: enabled,
                onChanged: (_) => ref
                    .read(notificationPrefsProvider.notifier)
                    .toggle(),
              ),
              loading: () => const ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Notifications'),
                trailing: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, st) => const ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Notifications'),
                subtitle: Text('Failed to load'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                await ref.read(categoriesRepositoryProvider).clearLocalCache();
                await ref.read(expensesRepositoryProvider).clearLocalCache();
                await ref.read(budgetsRepositoryProvider).clearLocalCache();
                ref.invalidate(isLoggedInProvider);
                ref.invalidate(categoriesProvider);
                ref.invalidate(expensesProvider);
                ref.invalidate(budgetsProvider);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}