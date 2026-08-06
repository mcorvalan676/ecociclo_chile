import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎁', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Recompensas',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primaryDark)),
            const SizedBox(height: 8),
            Text('Próximamente', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}