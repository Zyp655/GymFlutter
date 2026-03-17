import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromFirestore(
    Map<String, dynamic> data,
    String uid,
  ) {
    return UserProfileModel(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['display_name'] as String? ?? '',
      photoUrl: data['photo_url'] as String? ?? '',
      createdAt:
          DateTime.tryParse(data['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(data['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      uid: profile.uid,
      email: profile.email,
      displayName: profile.displayName,
      photoUrl: profile.photoUrl,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }
}
