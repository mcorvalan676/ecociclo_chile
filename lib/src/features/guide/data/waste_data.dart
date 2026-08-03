import 'package:flutter/material.dart';
import 'waste_item.dart';

class WasteData {
  WasteData._();

  static String categoryLabel(WasteCategory category) {
    switch (category) {
      case WasteCategory.paper:
        return 'Papel y Cartón';
      case WasteCategory.plastic:
        return 'Plástico';
      case WasteCategory.glass:
        return 'Vidrio';
      case WasteCategory.metal:
        return 'Metal';
      case WasteCategory.organic:
        return 'Orgánico';
      case WasteCategory.electronic:
        return 'Electrónico';
      case WasteCategory.batteries:
        return 'Pilas y Baterías';
      case WasteCategory.oil:
        return 'Aceite';
      case WasteCategory.textile:
        return 'Textil';
    }
  }

  static IconData categoryIcon(WasteCategory category) {
    switch (category) {
      case WasteCategory.paper:
        return Icons.description_outlined;
      case WasteCategory.plastic:
        return Icons.local_drink_outlined;
      case WasteCategory.glass:
        return Icons.wine_bar_outlined;
      case WasteCategory.metal:
        return Icons.hardware_outlined;
      case WasteCategory.organic:
        return Icons.eco_outlined;
      case WasteCategory.electronic:
        return Icons.devices_other_outlined;
      case WasteCategory.batteries:
        return Icons.battery_full_outlined;
      case WasteCategory.oil:
        return Icons.oil_barrel_outlined;
      case WasteCategory.textile:
        return Icons.checkroom_outlined;
    }
  }

  static Color categoryColor(WasteCategory category) {
    switch (category) {
      case WasteCategory.paper:
        return const Color(0xFF8D6E63);
      case WasteCategory.plastic:
        return const Color(0xFF0288D1);
      case WasteCategory.glass:
        return const Color(0xFF2E7D32);
      case WasteCategory.metal:
        return const Color(0xFF757575);
      case WasteCategory.organic:
        return const Color(0xFF6D4C41);
      case WasteCategory.electronic:
        return const Color(0xFFF57C00);
      case WasteCategory.batteries:
        return const Color(0xFFD32F2F);
      case WasteCategory.oil:
        return const Color(0xFF424242);
      case WasteCategory.textile:
        return const Color(0xFF7B1FA2);
    }
  }
}