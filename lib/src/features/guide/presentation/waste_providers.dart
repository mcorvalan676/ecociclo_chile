import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/waste_item.dart';
import '../data/waste_item_repository.dart';
import '../data/waste_items.dart';

final wasteItemRepositoryProvider = Provider<WasteItemRepository>(
  (ref) => WasteItemRepository(),
);

class WasteItemsNotifier extends StateNotifier<List<WasteItem>> {
  WasteItemsNotifier(this._repository) : super(WasteItemsRepository.items) {
    _load();
  }

  final WasteItemRepository _repository;

  Future<void> _load() async {
    try {
      final items = await _repository.fetchWasteItems();
      if (items.isNotEmpty) {
        state = items;
      }
    } catch (_) {
      // Mantiene los datos locales de WasteItemsRepository.items como fallback.
    }
  }
}

final wasteItemsProvider = StateNotifierProvider<WasteItemsNotifier, List<WasteItem>>(
  (ref) => WasteItemsNotifier(ref.watch(wasteItemRepositoryProvider)),
);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredWasteItemsProvider = Provider<List<WasteItem>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final allItems = ref.watch(wasteItemsProvider);
  if (query.isEmpty) return allItems;
  return allItems.where((item) {
    return item.name.toLowerCase().contains(query) ||
        item.keywords.any((k) => k.toLowerCase().contains(query));
  }).toList();
});

final selectedWasteItemProvider = StateProvider<WasteItem?>((ref) => null);