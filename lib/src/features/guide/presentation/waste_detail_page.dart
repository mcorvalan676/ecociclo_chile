import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_theme.dart';
import '../../accessibility/presentation/accessibility_page.dart';
import '../data/waste_data.dart';
import 'waste_providers.dart';

class WasteDetailPage extends ConsumerWidget {
  const WasteDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(selectedWasteItemProvider);
    final accessibilityNotifier = ref.read(accessibilityProvider.notifier);

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('No se seleccionó ningún residuo.')),
      );
    }

    final color = WasteData.categoryColor(item.category);

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(WasteData.categoryIcon(item.category), color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: Theme.of(context).textTheme.headlineMedium),
                        Text(WasteData.categoryLabel(item.category), style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                    tooltip: 'Escuchar toda la ficha',
                    onPressed: () => accessibilityNotifier.speak(
                      '${item.name}. Cómo prepararlo: ${item.preparation}. Dónde llevarlo: ${item.whereToTake}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _DetailSection(
                icon: Icons.build_outlined,
                title: '¿Cómo prepararlo?',
                content: item.preparation,
                onListen: () => accessibilityNotifier.speak(item.preparation),
              ),
              const SizedBox(height: 16),
              _DetailSection(
                icon: Icons.place_outlined,
                title: '¿Dónde llevarlo?',
                content: item.whereToTake,
                onListen: () => accessibilityNotifier.speak(item.whereToTake),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onListen;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.content,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16)),
              ),
              GestureDetector(
                onTap: onListen,
                child: const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}