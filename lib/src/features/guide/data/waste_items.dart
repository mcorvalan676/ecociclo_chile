import 'waste_item.dart';

class WasteItemsRepository {
  WasteItemsRepository._();

  static const List<WasteItem> items = [
    WasteItem(
      id: 'w001',
      name: 'Botella de plástico (PET)',
      category: WasteCategory.plastic,
      preparation: 'Enjuaga la botella, retira la etiqueta si es posible y aplástala para reducir su volumen. Deja la tapa puesta.',
      whereToTake: 'Punto limpio más cercano, contenedor de plásticos.',
      keywords: ['botella', 'plastico', 'pet', 'bebida'],
    ),
    WasteItem(
      id: 'w002',
      name: 'Caja de cartón',
      category: WasteCategory.paper,
      preparation: 'Retira cintas adhesivas y restos de plástico. Dobla o aplasta la caja para ahorrar espacio.',
      whereToTake: 'Punto limpio, contenedor de papel y cartón.',
      keywords: ['caja', 'carton', 'papel', 'embalaje'],
    ),
    WasteItem(
      id: 'w003',
      name: 'Botella de vidrio',
      category: WasteCategory.glass,
      preparation: 'Enjuaga y retira la tapa metálica o plástica (van en otro contenedor). No es necesario quitar la etiqueta.',
      whereToTake: 'Punto limpio, campana o contenedor de vidrio.',
      keywords: ['botella', 'vidrio', 'vino', 'cerveza'],
    ),
    WasteItem(
      id: 'w004',
      name: 'Lata de aluminio',
      category: WasteCategory.metal,
      preparation: 'Enjuaga la lata. Puedes aplastarla para ahorrar espacio.',
      whereToTake: 'Punto limpio, contenedor de metales.',
      keywords: ['lata', 'aluminio', 'metal', 'bebida'],
    ),
    WasteItem(
      id: 'w005',
      name: 'Restos de comida',
      category: WasteCategory.organic,
      preparation: 'Separa restos de comida cruda o cocida en un contenedor cerrado. Evita mezclar con líquidos en exceso.',
      whereToTake: 'Compostera comunitaria o punto limpio con línea orgánica.',
      keywords: ['comida', 'organico', 'compost', 'restos'],
    ),
    WasteItem(
      id: 'w006',
      name: 'Celular en desuso',
      category: WasteCategory.electronic,
      preparation: 'Realiza un respaldo de tus datos y borra la información personal (reinicio de fábrica) antes de entregarlo.',
      whereToTake: 'Punto limpio con línea de e-waste o tiendas con puntos de retorno.',
      keywords: ['celular', 'telefono', 'electronico', 'e-waste'],
    ),
    WasteItem(
      id: 'w007',
      name: 'Pilas alcalinas',
      category: WasteCategory.batteries,
      preparation: 'No las mezcles con la basura común. Guárdalas en un contenedor cerrado hasta llevarlas a un punto de acopio.',
      whereToTake: 'Punto limpio, contenedor especial de pilas.',
      keywords: ['pila', 'bateria', 'alcalina'],
    ),
    WasteItem(
      id: 'w008',
      name: 'Aceite de cocina usado',
      category: WasteCategory.oil,
      preparation: 'Deja enfriar y guarda el aceite en una botella plástica bien cerrada. Nunca lo viertas por el desagüe.',
      whereToTake: 'Punto limpio con línea de aceites, algunos municipios tienen recolección especial.',
      keywords: ['aceite', 'cocina', 'fritura'],
    ),
    WasteItem(
      id: 'w009',
      name: 'Ropa en buen estado',
      category: WasteCategory.textile,
      preparation: 'Lava la prenda y dóblala. Si está en mal estado, sepárala para reciclaje textil en vez de donación.',
      whereToTake: 'Punto limpio con línea textil, contenedores de donación o fundaciones.',
      keywords: ['ropa', 'textil', 'tela', 'donacion'],
    ),
    WasteItem(
      id: 'w010',
      name: 'Periódico y revistas',
      category: WasteCategory.paper,
      preparation: 'Mantén el papel seco y libre de restos de comida o grasa. Puedes amarrarlos en pilas.',
      whereToTake: 'Punto limpio, contenedor de papel.',
      keywords: ['periodico', 'revista', 'diario', 'papel'],
    ),
  ];

  static List<WasteItem> search(String query) {
    if (query.trim().isEmpty) return items;
    final normalized = query.toLowerCase().trim();
    return items.where((item) {
      return item.name.toLowerCase().contains(normalized) ||
          item.keywords.any((k) => k.contains(normalized));
    }).toList();
  }
}