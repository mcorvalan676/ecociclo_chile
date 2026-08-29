
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/themes/app_theme.dart';
import 'src/core/widgets/main_navigation_shell.dart';
import 'src/features/accessibility/presentation/accessibility_page.dart';
import 'src/features/auth/presentation/auth_providers.dart';
import 'src/features/auth/presentation/login_page.dart';

class EcoCicloApp extends ConsumerWidget {
  const EcoCicloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibility = ref.watch(accessibilityProvider);

    return MaterialApp(
      title: 'EcoCiclo Chile',
      debugShowCheckedModeBanner: false,
      theme: accessibility.highContrastEnabled
          ? AppTheme.highContrastTheme
          : AppTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accessibility.textScaleFactor),
          ),
          child: child!,
        );
      },
      home: const _AuthGate(),
    );
  }
}

/// Decide qué mostrar según el estado de autenticación:
/// - Cargando: spinner mientras se comprueba si hay sesión guardada.
/// - Sin sesión: pantalla de login.
/// - Con sesión: la app normal.
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (_, __) => const LoginPage(),
      data: (user) => user == null ? const LoginPage() : const MainNavigationShell(),
    );
  }
}