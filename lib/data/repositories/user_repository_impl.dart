import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/app_logger.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'users';

  UserRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfileModel.fromFirestore(doc.data()!, uid);
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Error getting user profile', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> createProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await _firestore
          .collection(_collection)
          .doc(profile.uid)
          .set(model.toFirestore());
    } catch (e, stackTrace) {
      AppLogger.e('Error creating user profile', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await _firestore
          .collection(_collection)
          .doc(profile.uid)
          .update(model.toFirestore());
    } catch (e, stackTrace) {
      AppLogger.e('Error updating user profile', e, stackTrace);
      rethrow;
    }
  }
}
