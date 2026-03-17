import '../../domain/entities/gym.dart';

class GymModel extends Gym {
  const GymModel({
    super.id,
    required super.name,
    required super.address,
    required super.phoneNumber,
    required super.email,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.latitude,
    required super.longitude,
    required super.openingHours,
    required super.facilities,
    super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GymModel.fromMap(Map<String, dynamic> map) {
    return GymModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      phoneNumber: map['phone_number'] as String,
      email: map['email'] as String,
      description: map['description'] as String,
      imageUrl: map['image_url'] as String,
      rating: (map['rating'] as num).toDouble(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      openingHours: map['opening_hours'] as String,
      facilities: (map['facilities'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
      createdBy: map['created_by'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'opening_hours': openingHours,
      'facilities': facilities.join(','),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory GymModel.fromEntity(Gym gym) {
    return GymModel(
      id: gym.id,
      name: gym.name,
      address: gym.address,
      phoneNumber: gym.phoneNumber,
      email: gym.email,
      description: gym.description,
      imageUrl: gym.imageUrl,
      rating: gym.rating,
      latitude: gym.latitude,
      longitude: gym.longitude,
      openingHours: gym.openingHours,
      facilities: gym.facilities,
      createdBy: gym.createdBy,
      createdAt: gym.createdAt,
      updatedAt: gym.updatedAt,
    );
  }
}
