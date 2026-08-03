enum WasteCategory { paper, plastic, glass, metal, organic, electronic, batteries, oil, textile }

class WasteItem {
  final String id;
  final String name;
  final WasteCategory category;
  final String preparation;
  final String whereToTake;
  final List<String> keywords;

  const WasteItem({
    required this.id,
    required this.name,
    required this.category,
    required this.preparation,
    required this.whereToTake,
    required this.keywords,
  });

  factory WasteItem.fromMap(Map<String, dynamic> map) {
    return WasteItem(
      id: map['\$id'] as String,
      name: map['name'] as String,
      category: WasteCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => WasteCategory.plastic,
      ),
      preparation: map['preparation'] as String,
      whereToTake: map['whereToTake'] as String,
      keywords: List<String>.from(map['keywords'] as List),
    );
  }
}