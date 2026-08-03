import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../data/clean_point_repository.dart';
import '../data/map_locations.dart';

class MapState {
  final bool isLoading;
  final String? errorMessage;
  final LatLng? currentLocation;
  final CleanPoint? selectedPoint;
  final List<CleanPoint> cleanPoints;
  final bool usingFallbackData;

  const MapState({
    this.isLoading = false,
    this.errorMessage,
    this.currentLocation,
    this.selectedPoint,
    this.cleanPoints = const [],
    this.usingFallbackData = false,
  });

  MapState copyWith({
    bool? isLoading,
    String? errorMessage,
    LatLng? currentLocation,
    CleanPoint? selectedPoint,
    List<CleanPoint>? cleanPoints,
    bool? usingFallbackData,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentLocation: currentLocation ?? this.currentLocation,
      selectedPoint: clearSelected ? null : (selectedPoint ?? this.selectedPoint),
      cleanPoints: cleanPoints ?? this.cleanPoints,
      usingFallbackData: usingFallbackData ?? this.usingFallbackData,
    );
  }
}

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier(this._repository) : super(const MapState()) {
    loadCleanPoints();
  }

  final CleanPointRepository _repository;

  Future<void> loadCleanPoints() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final points = await _repository.fetchCleanPoints();
      state = state.copyWith(
        isLoading: false,
        cleanPoints: points.isNotEmpty ? points : MapLocationsData.fallbackCleanPoints,
        usingFallbackData: points.isEmpty,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        cleanPoints: MapLocationsData.fallbackCleanPoints,
        usingFallbackData: true,
        errorMessage: 'No se pudo conectar a Appwrite. Mostrando datos locales.',
      );
    }
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'El servicio de ubicación está desactivado.',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Permiso de ubicación denegado.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Permiso de ubicación denegado permanentemente.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      state = state.copyWith(
        isLoading: false,
        currentLocation: LatLng(position.latitude, position.longitude),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo obtener la ubicación.',
      );
    }
  }

  void selectPoint(CleanPoint point) {
    state = state.copyWith(selectedPoint: point);
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true);
  }
}

final cleanPointRepositoryProvider = Provider<CleanPointRepository>(
  (ref) => CleanPointRepository(),
);

final mapProvider = StateNotifierProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(ref.watch(cleanPointRepositoryProvider)),
);