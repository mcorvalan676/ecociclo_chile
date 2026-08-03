class EcobotResponse {
  final List<String> triggers;
  final String reply;

  const EcobotResponse({required this.triggers, required this.reply});
}

class EcobotData {
  EcobotData._();

  static const String welcomeMessage =
      '¡Hola! Soy EcoBot 🌱 Pregúntame sobre reciclaje: qué hacer con plástico, '
      'vidrio, pilas, dónde encontrar puntos limpios, o cómo funciona la app.';

  static const String fallbackMessage =
      'No tengo una respuesta para eso todavía. Prueba preguntando sobre '
      'plástico, vidrio, papel, pilas, aceite, electrónicos o puntos limpios.';

  static const List<EcobotResponse> responses = [
    EcobotResponse(
      triggers: ['hola', 'buenas', 'hey'],
      reply: '¡Hola! ¿En qué puedo ayudarte a reciclar hoy?',
    ),
    EcobotResponse(
      triggers: ['plastico', 'plástico', 'botella'],
      reply: 'Las botellas y envases plásticos se enjuagan, se aplastan y se '
          'llevan al contenedor de plásticos del punto limpio más cercano.',
    ),
    EcobotResponse(
      triggers: ['vidrio', 'botella de vidrio'],
      reply: 'El vidrio se enjuaga y se deposita en la campana o contenedor '
          'de vidrio. Recuerda quitar tapas metálicas o plásticas.',
    ),
    EcobotResponse(
      triggers: ['papel', 'carton', 'cartón', 'caja'],
      reply: 'El papel y cartón deben estar secos y sin restos de comida. '
          'Dobla las cajas para ahorrar espacio antes de llevarlas al punto limpio.',
    ),
    EcobotResponse(
      triggers: ['pila', 'pilas', 'bateria', 'batería'],
      reply: 'Las pilas y baterías nunca van con la basura común. Guárdalas '
          'aparte y llévalas a un contenedor especial en el punto limpio.',
    ),
    EcobotResponse(
      triggers: ['aceite'],
      reply: 'El aceite de cocina usado se guarda frío en una botella cerrada '
          'y se lleva a un punto limpio con línea de aceites. Nunca lo viertas por el desagüe.',
    ),
    EcobotResponse(
      triggers: ['electronico', 'electrónico', 'celular', 'e-waste'],
      reply: 'Los residuos electrónicos (celulares, cables, etc.) se entregan '
          'en puntos limpios con línea de e-waste. Borra tus datos antes de entregarlos.',
    ),
    EcobotResponse(
      triggers: ['organico', 'orgánico', 'comida', 'compost'],
      reply: 'Los restos orgánicos pueden compostarse en composteras comunitarias '
          'o entregarse en puntos limpios con línea orgánica.',
    ),
    EcobotResponse(
      triggers: ['punto limpio', 'puntos limpios', 'donde', 'dónde', 'mapa'],
      reply: 'Puedes ver todos los puntos limpios disponibles en la pestaña '
          '"Mapa" de la app, con su dirección y horario de atención.',
    ),
    EcobotResponse(
      triggers: ['gracias'],
      reply: '¡De nada! Cada residuo bien separado hace la diferencia 🌍',
    ),
  ];

  static String getReply(String userMessage) {
    final normalized = userMessage.toLowerCase().trim();
    for (final response in responses) {
      if (response.triggers.any((trigger) => normalized.contains(trigger))) {
        return response.reply;
      }
    }
    return fallbackMessage;
  }
}