import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/themes/app_theme.dart';
import 'src/core/widgets/main_navigation_shell.dart';
import 'src/features/accessibility/presentation/accessibility_page.dart';

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
      home: const MainNavigationShell(),
    );
  }
}