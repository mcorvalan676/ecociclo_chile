import 'package:appwrite/appwrite.dart';

class AchievementSyncService {
  final Databases databases;

  AchievementSyncService(this.databases);

  Future<void> migrateLocalAchievementsToCloud({
    required String newUserId,
    required List<String> localAchievementIds,
    required String databaseId,
    required String collectionId,
  }) async {
    for (var achievementId in localAchievementIds) {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          'userId': newUserId,
          'achievementId': achievementId,
          'unlockedAt': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}