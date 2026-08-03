import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../data/map_locations.dart';
import 'map_providers.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);

    ref.listen<MapState>(mapProvider, (previous, next) {
      if (next.currentLocation != null &&
          previous?.currentLocation != next.currentLocation) {
        _mapController.move(next.currentLocation!, 14);
      }
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Puntos Limpios')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: MapLocationsData.santiagoCenter,
              initialZoom: 12,
              minZoom: 4,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ecociclo.chile',
              ),
              MarkerLayer(
                markers: [
                  ...mapState.cleanPoints.map(
                    (point) => Marker(
                      point: point.location,
                      width: 44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () => mapNotifier.selectPoint(point),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  if (mapState.currentLocation != null)
                    Marker(
                      point: mapState.currentLocation!,
                      width: 30,
                      height: 30,
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.secondary,
                        size: 26,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: mapState.selectedPoint != null ? 180 : 20,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'locate_me',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              onPressed: mapState.isLoading
                  ? null
                  : () => mapNotifier.getCurrentLocation(),
              child: mapState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
          if (mapState.selectedPoint != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _CleanPointCard(
                point: mapState.selectedPoint!,
                onClose: mapNotifier.clearSelection,
              ),
            ),
        ],
      ),
    );
  }
}

class _CleanPointCard extends StatelessWidget {
  final CleanPoint point;
  final VoidCallback onClose;

  const _CleanPointCard({required this.point, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  point.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(point.address, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(point.schedule, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: point.acceptedWaste
                .map(
                  (type) => Chip(
                    label: Text(MapLocationsData.wasteTypeLabel(type)),
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                    labelStyle: const TextStyle(color: AppColors.primaryDark),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}