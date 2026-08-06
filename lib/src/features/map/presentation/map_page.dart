import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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

  static const _filters = <WasteType?>[
    null,
    WasteType.plastic,
    WasteType.glass,
    WasteType.textile,
    WasteType.paper,
  ];

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final open24hOnly = ref.watch(mapOpen24hOnlyProvider);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtros', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Solo abiertos 24 horas'),
                    value: open24hOnly,
                    activeColor: AppColors.primary,
                    onChanged: (value) => ref.read(mapOpen24hOnlyProvider.notifier).state = value,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);
    final filteredPoints = ref.watch(filteredCleanPointsProvider);
    final activeCategory = ref.watch(mapCategoryFilterProvider);

    ref.listen<MapState>(mapProvider, (previous, next) {
      if (next.currentLocation != null && previous?.currentLocation != next.currentLocation) {
        _mapController.move(next.currentLocation!, 14);
      }
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                 GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
                      child: const Icon(Icons.arrow_back, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Puntos Limpios', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                        Text('Encuentra tu punto más cercano', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(100), boxShadow: AppShadows.card),
                      child: TextField(
                        onChanged: (value) => ref.read(mapSearchQueryProvider.notifier).state = value,
                        decoration: const InputDecoration(
                          hintText: 'Buscar puntos de reciclaje...',
                          prefixIcon: Icon(Icons.search, size: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _openFilterSheet,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
                      child: const Icon(Icons.tune, size: 20, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isActive = activeCategory == filter;
                  return ChoiceChip(
                    label: Text(filter == null ? 'Todos' : MapLocationsData.wasteTypeLabel(filter)),
                    selected: isActive,
                    onSelected: (_) => ref.read(mapCategoryFilterProvider.notifier).state = filter,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    child: FlutterMap(
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
                            ...filteredPoints.map(
                              (point) => Marker(
                                point: point.location,
                                width: 44,
                                height: 44,
                                child: GestureDetector(
                                  onTap: () => mapNotifier.selectPoint(point),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                    ),
                                    child: const Icon(Icons.recycling, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ),
                            if (mapState.currentLocation != null)
                              Marker(
                                point: mapState.currentLocation!,
                                width: 24,
                                height: 24,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryAlt,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Column(
                      children: [
                        _RoundIconButton(icon: Icons.add, onTap: () {
                          _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
                        }),
                        const SizedBox(height: 8),
                        _RoundIconButton(icon: Icons.remove, onTap: () {
                          _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
                        }),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: _RoundIconButton(
                      icon: Icons.my_location,
                      onTap: mapState.isLoading ? null : () => mapNotifier.getCurrentLocation(),
                      loading: mapState.isLoading,
                    ),
                  ),
                  if (mapState.selectedPoint != null)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: _CleanPointBottomSheet(
                        point: mapState.selectedPoint!,
                        onClose: mapNotifier.clearSelection,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;

  const _RoundIconButton({required this.icon, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
        child: loading
            ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(icon, size: 20, color: AppColors.primary),
      ),
    );
  }
}

class _CleanPointBottomSheet extends StatelessWidget {
  final CleanPoint point;
  final VoidCallback onClose;

  const _CleanPointBottomSheet({required this.point, required this.onClose});

  Future<void> _openDirections(BuildContext context) async {
    final lat = point.location.latitude;
    final lng = point.location.longitude;
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el mapa de navegación.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.bottomSheet),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: const Text('✓ Más cercano',
                    style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(point.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            point.isOpen24h ? 'Abierto 24 horas' : point.schedule,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: point.acceptedWaste
                .map(
                  (type) => Chip(
                    label: Text(MapLocationsData.wasteTypeLabel(type)),
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                    labelStyle: const TextStyle(color: AppColors.primaryDark, fontSize: 12, fontWeight: FontWeight.w600),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(point.address, style: Theme.of(context).textTheme.bodyMedium),
              ),
              GestureDetector(
                onTap: () => _openDirections(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: AppColors.secondaryAlt, shape: BoxShape.circle),
                  child: const Icon(Icons.navigation_rounded, color: AppColors.primaryDark, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}