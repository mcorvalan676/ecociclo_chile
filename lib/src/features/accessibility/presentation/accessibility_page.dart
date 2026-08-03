import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/themes/app_theme.dart';

class AccessibilityState {
  final bool highContrastEnabled;
  final double textScaleFactor;
  final bool ttsEnabled;
  final bool isSpeaking;

  const AccessibilityState({
    this.highContrastEnabled = false,
    this.textScaleFactor = 1.0,
    this.ttsEnabled = false,
    this.isSpeaking = false,
  });

  AccessibilityState copyWith({
    bool? highContrastEnabled,
    double? textScaleFactor,
    bool? ttsEnabled,
    bool? isSpeaking,
  }) {
    return AccessibilityState(
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }
}

class AccessibilityNotifier extends StateNotifier<AccessibilityState> {
  AccessibilityNotifier() : super(const AccessibilityState()) {
    _tts.setLanguage('es-CL');
    _tts.setSpeechRate(0.45);
    _tts.setCompletionHandler(() {
      state = state.copyWith(isSpeaking: false);
    });
  }

  final FlutterTts _tts = FlutterTts();

  void toggleHighContrast() {
    state = state.copyWith(highContrastEnabled: !state.highContrastEnabled);
  }

  void increaseTextScale() {
    if (state.textScaleFactor < 1.6) {
      state = state.copyWith(textScaleFactor: state.textScaleFactor + 0.2);
    }
  }

  void decreaseTextScale() {
    if (state.textScaleFactor > 1.0) {
      state = state.copyWith(textScaleFactor: state.textScaleFactor - 0.2);
    }
  }

  void toggleTts() {
    state = state.copyWith(ttsEnabled: !state.ttsEnabled);
    if (!state.ttsEnabled) {
      _tts.stop();
      state = state.copyWith(isSpeaking: false);
    }
  }

  Future<void> speak(String text) async {
    if (!state.ttsEnabled || text.trim().isEmpty) return;
    state = state.copyWith(isSpeaking: true);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    state = state.copyWith(isSpeaking: false);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}

final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilityState>(
  (ref) => AccessibilityNotifier(),
);

class AccessibilityPage extends ConsumerWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibility = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Modo Accesible')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _AccessibilityCard(
              icon: Icons.contrast,
              title: 'Alto contraste',
              subtitle: 'Colores de alto contraste para mejor visibilidad.',
              trailing: Switch(
                value: accessibility.highContrastEnabled,
                onChanged: (_) => notifier.toggleHighContrast(),
              ),
            ),
            const SizedBox(height: 12),
            _AccessibilityCard(
              icon: Icons.record_voice_over,
              title: 'Lectura en voz alta',
              subtitle: 'Activa para que EcoBot y las fichas se lean en voz alta.',
              trailing: Switch(
                value: accessibility.ttsEnabled,
                onChanged: (_) => notifier.toggleTts(),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Tamaño de texto: ${accessibility.textScaleFactor.toStringAsFixed(1)}x',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: notifier.decreaseTextScale,
                          icon: const Icon(Icons.remove),
                          label: const Text('Reducir'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: notifier.increaseTextScale,
                          icon: const Icon(Icons.add),
                          label: const Text('Aumentar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => notifier.speak(
                'Este es un ejemplo de cómo EcoBot leerá las respuestas en voz alta.',
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Probar lectura en voz alta'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessibilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _AccessibilityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16)),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}