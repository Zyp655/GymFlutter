import 'package:equatable/equatable.dart';

class Gym extends Equatable {
  final int? id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String description;
  final String imageUrl;
  final double rating;
  final double latitude;
  final double longitude;
  final String openingHours;
  final List<String> facilities;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Gym({
    this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.facilities,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Gym copyWith({
    int? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? email,
    String? description,
    String? imageUrl,
    double? rating,
    double? latitude,
    double? longitude,
    String? openingHours,
    List<String>? facilities,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Gym(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      facilities: facilities ?? this.facilities,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phoneNumber,
    email,
    description,
    imageUrl,
    rating,
    latitude,
    longitude,
    openingHours,
    facilities,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
