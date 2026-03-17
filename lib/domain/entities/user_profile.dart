import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.photoUrl = '',
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    createdAt,
    updatedAt,
  ];
}
