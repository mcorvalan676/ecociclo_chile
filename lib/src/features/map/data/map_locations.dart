import 'package:latlong2/latlong.dart';

enum WasteType { paper, plastic, glass, metal, organic, electronic, batteries, oil }

class CleanPoint {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final List<WasteType> acceptedWaste;
  final String schedule;

  const CleanPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.acceptedWaste,
    required this.schedule,
  });

  factory CleanPoint.fromMap(Map<String, dynamic> map) {
    return CleanPoint(
      id: map['\$id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      location: LatLng(
        (map['latitude'] as num).toDouble(),
        (map['longitude'] as num).toDouble(),
      ),
      acceptedWaste: (map['acceptedWaste'] as List)
          .map((e) => WasteType.values.firstWhere(
                (w) => w.name == e,
                orElse: () => WasteType.plastic,
              ))
          .toList(),
      schedule: map['schedule'] as String,
    );
  }
}

class MapLocationsData {
  MapLocationsData._();

  static const LatLng santiagoCenter = LatLng(-33.4489, -70.6693);

  static const List<CleanPoint> fallbackCleanPoints = [
    CleanPoint(
      id: 'cp001',
      name: 'Punto Limpio Providencia',
      address: 'Av. Providencia 2359, Providencia',
      location: LatLng(-33.4260, -70.6183),
      acceptedWaste: [WasteType.paper, WasteType.plastic, WasteType.glass, WasteType.metal],
      schedule: 'Lun a Sáb 09:00 - 18:00',
    ),
    CleanPoint(
      id: 'cp002',
      name: 'Punto Limpio Ñuñoa',
      address: 'Av. Irarrázaval 3625, Ñuñoa',
      location: LatLng(-33.4558, -70.5979),
      acceptedWaste: [WasteType.paper, WasteType.plastic, WasteType.electronic],
      schedule: 'Lun a Vie 09:00 - 17:30',
    ),
    CleanPoint(
      id: 'cp003',
      name: 'Punto Limpio Las Condes',
      address: 'Av. Apoquindo 4501, Las Condes',
      location: LatLng(-33.4103, -70.5677),
      acceptedWaste: [WasteType.glass, WasteType.metal, WasteType.batteries, WasteType.oil],
      schedule: 'Todos los días 08:30 - 19:00',
    ),
  ];

  static String wasteTypeLabel(WasteType type) {
    switch (type) {
      case WasteType.paper:
        return 'Papel y Cartón';
      case WasteType.plastic:
        return 'Plástico';
      case WasteType.glass:
        return 'Vidrio';
      case WasteType.metal:
        return 'Metal';
      case WasteType.organic:
        return 'Orgánico';
      case WasteType.electronic:
        return 'Electrónico';
      case WasteType.batteries:
        return 'Pilas y Baterías';
      case WasteType.oil:
        return 'Aceite';
    }
  }
}