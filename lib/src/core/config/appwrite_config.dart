import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  AppwriteConfig._();

  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = '6a6e8b260003fefedc9b';
  static const String databaseId = '6a6e8bf80013de2be331';
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
}