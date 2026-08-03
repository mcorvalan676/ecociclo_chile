import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_theme.dart';
import '../data/waste_data.dart';
import '../data/waste_item.dart';
import 'waste_detail_page.dart';
import 'waste_providers.dart';

class GuidePage extends ConsumerWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItems = ref.watch(filteredWasteItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Guía de Residuos')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
                decoration: InputDecoration(
                  hintText: 'Busca un residuo (ej: botella, pilas...)',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No encontramos resultados. Intenta con otro término.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _WasteListTile(item: item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WasteListTile extends ConsumerWidget {
  final WasteItem item;

  const _WasteListTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = WasteData.categoryColor(item.category);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(WasteData.categoryIcon(item.category), color: color),
        ),
        title: Text(item.name),
        subtitle: Text(WasteData.categoryLabel(item.category)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ref.read(selectedWasteItemProvider.notifier).state = item;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WasteDetailPage()),
          );
        },
      ),
    );
  }
}