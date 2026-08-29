import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

/// Estado de autenticación de toda la app.
/// - AsyncLoading: todavía estamos comprobando si hay una sesión guardada.
/// - AsyncData(null): no hay sesión, hay que mostrar el login.
/// - AsyncData(user): hay sesión activa, se puede mostrar la app normal.
class AuthNotifier extends AsyncNotifier<models.User?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<models.User?> build() {
    return _repository.getCurrentUser();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.login(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.register(name: name, email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, models.User?>(AuthNotifier.new);