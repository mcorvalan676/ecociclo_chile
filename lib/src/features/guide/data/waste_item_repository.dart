import 'package:appwrite/appwrite.dart';
import '../../../core/config/appwrite_config.dart';
import 'waste_item.dart';

class WasteItemRepository {
  final Databases _databases = AppwriteClientService().databases;

  Future<List<WasteItem>> fetchWasteItems() async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.wasteItemsCollectionId,
    );

    return result.documents
        .map((doc) => WasteItem.fromMap(doc.data..['\$id'] = doc.$id))
        .toList();
  }
}