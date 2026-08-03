import 'package:appwrite/appwrite.dart';
import '../../../core/config/appwrite_config.dart';
import 'map_locations.dart';

class CleanPointRepository {
  final Databases _databases = AppwriteClientService().databases;

  Future<List<CleanPoint>> fetchCleanPoints() async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.cleanPointsCollectionId,
    );

    return result.documents
        .map((doc) => CleanPoint.fromMap(doc.data..['\$id'] = doc.$id))
        .toList();
  }
}