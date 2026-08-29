import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../../core/config/appwrite_config.dart';

/// Excepción con un mensaje ya traducido al español, listo para mostrar
/// directamente en la UI (por ejemplo en un SnackBar o un texto de error).
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final Account _account = AppwriteClientService().account;

  /// Devuelve el usuario actual si hay una sesión activa, o null si no la hay.
  /// No lanza excepción cuando no hay sesión: eso es un estado normal (deslogueado).
  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      // 401 = no hay sesión activa. Es esperado, no es un error real.
      if (e.code == 401) return null;
      rethrow;
    }
  }

  Future<models.User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      // Appwrite no inicia sesión automáticamente al crear la cuenta,
      // así que la iniciamos nosotros justo después de registrar.
      return await login(email: email, password: password);
    } on AppwriteException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  Future<models.User> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(email: email, password: password);
      return await _account.get();
    } on AppwriteException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  /// Traduce los códigos/errores más comunes de Appwrite a mensajes
  /// entendibles en español para el usuario final.
  String _mapError(AppwriteException e) {
    switch (e.type) {
      case 'user_already_exists':
        return 'Ya existe una cuenta con ese correo.';
      case 'user_invalid_credentials':
        return 'Correo o contraseña incorrectos.';
      case 'user_email_already_exists':
        return 'Ese correo ya está registrado.';
      case 'general_argument_invalid':
        return 'Revisa que los datos ingresados sean válidos.';
      default:
        if (e.code == 401) return 'Correo o contraseña incorrectos.';
        return e.message ?? 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}