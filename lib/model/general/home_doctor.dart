import 'package:json_annotation/json_annotation.dart';

part 'home_doctor.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeDoctor {
  const HomeDoctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specializations,
    required this.clinicName,
    required this.location,
    required this.isLiked,
    this.distance,
    this.clinicImage,
    this.image,
  });

  factory HomeDoctor.fromJson(Map<String, dynamic> json) =>
      _$HomeDoctorFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final List<String> specializations;
  final String? clinicImage;
  final String? image;
  final String clinicName;
  final String location;
  final bool isLiked;
  final double? distance; // Changed to nullable

  // Convenience getter for display purposes
  double get displayDistance => distance ?? 0.0;

  // Convenience getter for distance text
  String get distanceText =>
      distance != null ? '${distance!.toStringAsFixed(1)} km' : 'Distance N/A';

  Map<String, dynamic> toJson() => _$HomeDoctorToJson(this);

  // Add copyWith method for updating instances
  HomeDoctor copyWith({
    String? id,
    String? firstName,
    String? lastName,
    List<String>? specializations,
    String? clinicImage,
    String? image,
    String? clinicName,
    String? location,
    bool? isLiked,
    double? distance,
  }) {
    return HomeDoctor(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      specializations: specializations ?? this.specializations,
      clinicImage: clinicImage ?? this.clinicImage,
      image: image ?? this.image,
      clinicName: clinicName ?? this.clinicName,
      location: location ?? this.location,
      isLiked: isLiked ?? this.isLiked,
      distance: distance ?? this.distance,
    );
  }
}
