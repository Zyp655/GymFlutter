import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/app_logger.dart';
import '../models/gym_model.dart';

class GymRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'gyms';

  GymRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<GymModel>> fetchGyms({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('created_at', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = int.tryParse(doc.id) ?? 0;
        return GymModel.fromMap(data);
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching remote gyms', e, stackTrace);
      return [];
    }
  }

  Future<void> uploadGym(GymModel gym) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(gym.id.toString())
          .set(gym.toMap(), SetOptions(merge: true));
    } catch (e, stackTrace) {
      AppLogger.e('Error uploading gym', e, stackTrace);
      rethrow;
    }
  }
}
