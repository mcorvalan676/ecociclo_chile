import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoCiclo Chile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.recycling, size: 72, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Bienvenido a EcoCiclo Chile',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Encuentra puntos limpios, aprende a reciclar y resuelve tus dudas con nuestro EcoBot.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}