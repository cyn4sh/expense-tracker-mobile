import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'auth_screen.dart';
import '../../../../core/navigation/main_nav_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedInAsync = ref.watch(isLoggedInProvider);

    return isLoggedInAsync.when(
      data: (isLoggedIn) =>
          isLoggedIn ? const MainNavScreen() : const AuthScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const AuthScreen(),
    );
  }
}