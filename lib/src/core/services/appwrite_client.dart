import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  AppwriteConfig._();

  // TODO en el sentido de "reemplazar por tus valores reales" (no lógica pendiente):
  // Crea tu proyecto en https://cloud.appwrite.io y reemplaza estos valores.
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = 'TU_PROJECT_ID_AQUI';
  static const String databaseId = 'TU_DATABASE_ID_AQUI';
  static const String cleanPointsCollectionId = 'clean_points';
  static const String wasteItemsCollectionId = 'waste_items';
}

class AppwriteClientService {
  static final AppwriteClientService _instance = AppwriteClientService._internal();

  factory AppwriteClientService() => _instance;

  AppwriteClientService._internal() {
    client = Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);
  }

  late final Client client;

  Databases get databases => Databases(client);

  Account get account => Account(client);

  Storage get storage => Storage(client);
}