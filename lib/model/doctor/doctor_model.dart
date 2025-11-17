import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DoctorModel {
  DoctorModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.id,
    this.bio,
    this.experience,
    this.location,
    this.lat,
    this.lng,
    this.specializations,
    this.brandTechnique,
    this.medicalSpecialty,
    this.procedures,
    this.verificationDocs,
    this.image,
    this.clinicImage,
    this.clinicName,
    this.verified,
    this.medicalOpinionRequest,
    this.bookingLink,
    this.rating,
    this.isLiked,
    this.distance,
    this.emailVerified,
    this.totalClicks,
    this.clicksLeft,
    this.isSubscribed,
    this.subscriptionType,
    this.rejectionReason,
    this.rejectedAt,
    this.createdAt,
    this.updatedAt,
    this.stripeCustomerId,
    this.stripeAccountId,
    this.withdrawable,
    this.totalEarnings,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  factory DoctorModel.empty() => DoctorModel(
        firstName: '',
        lastName: '',
        email: '',
      );

  @JsonKey(name: '_id')
  String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? bio;
  final int? experience;
  final String? location;
  final double? lat;
  final double? lng;
  final double? rating;
  final bool? isLiked;
  final double? distance;
  final List<String>? specializations;
  final List<String>? brandTechnique;
  final List<String>? medicalSpecialty;
  final List<ProcedureModel>? procedures;
  final List<Docs>? verificationDocs;
  final String? image;
  final String? clinicImage;
  final String? clinicName;
  final int? verified;
  @JsonKey(defaultValue: false)
  final bool? medicalOpinionRequest;
  final String? bookingLink;
  final bool? emailVerified;
  final bool? isSubscribed;
  final String? subscriptionType;
  final String? rejectionReason;
  final DateTime? rejectedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? stripeCustomerId; //Subscription & Payments
  final String? stripeAccountId; //Withdraw Money
  @JsonKey(name: 'withdrawable')
  final int? withdrawable;
  @JsonKey(name: 'total_earning')
  final int? totalEarnings;
  @JsonKey(name: 'total_clicks')
  final int? totalClicks;
  @JsonKey(name: 'clicks_left')
  final int? clicksLeft;

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  DoctorModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? bio,
    int? experience,
    String? location,
    double? lat,
    double? lng,
    List<String>? specializations,
    List<String>? brandTechnique,
    List<String>? medicalSpecialty,
    List<ProcedureModel>? procedures,
    List<Docs>? verificationDocs,
    String? image,
    String? clinicImage,
    String? clinicName,
    int? verified,
    String? bookingLink,
    bool? medicalOpinionRequest,
    double? rating,
    bool? isLiked,
    double? distance,
    bool? emailVerified,
    int? clicksLeft,
    int? totalClicks,
    bool? isSubscribed,
    String? subscriptionType,
    String? rejectionReason,
    DateTime? rejectedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? stripeCustomerId,
    String? stripeAccountId,
    int? withdrawable,
    int? totalEarnings,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      specializations: specializations ?? this.specializations,
      medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
      brandTechnique: brandTechnique ?? this.brandTechnique,
      procedures: procedures ?? this.procedures,
      verificationDocs: verificationDocs ?? this.verificationDocs,
      image: image ?? this.image,
      clinicImage: clinicImage ?? this.clinicImage,
      clinicName: clinicName ?? this.clinicName,
      verified: verified ?? this.verified,
      bookingLink: bookingLink ?? this.bookingLink,
      medicalOpinionRequest:
          medicalOpinionRequest ?? this.medicalOpinionRequest,
      rating: rating ?? this.rating,
      isLiked: isLiked ?? this.isLiked,
      distance: distance ?? this.distance,
      emailVerified: emailVerified ?? this.emailVerified,
      totalClicks: totalClicks ?? this.totalClicks,
      clicksLeft: clicksLeft ?? this.clicksLeft,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      withdrawable: withdrawable ?? this.withdrawable,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProcedureModel {
  ProcedureModel({
    required this.procedureType,
    this.id,
    this.currency,
    this.priceRange,
    this.beforeAfterPictures,
  });

  factory ProcedureModel.fromJson(Map<String, dynamic> json) =>
      _$ProcedureModelFromJson(json);

  @JsonKey(name: '_id', includeIfNull: false)
  final String? id;
  final String procedureType;
  final String? currency;
  final PriceRange? priceRange;
  final List<BeforeAfterModel>? beforeAfterPictures;

  Map<String, dynamic> toJson() => _$ProcedureModelToJson(this);

  ProcedureModel copyWith({
    String? id,
    String? procedureType,
    String? currency,
    PriceRange? priceRange,
    List<BeforeAfterModel>? beforeAfterPictures,
  }) {
    return ProcedureModel(
      id: id ?? this.id,
      procedureType: procedureType ?? this.procedureType,
      currency: currency ?? this.currency,
      priceRange: priceRange ?? this.priceRange,
      beforeAfterPictures: beforeAfterPictures ?? this.beforeAfterPictures,
    );
  }

  bool get isComplete {
    if (procedureType.isEmpty) return false;
    if (priceRange != null) {
      if (priceRange!.min == null || priceRange!.max == null) {
        return false;
      }
    }
    if (beforeAfterPictures == null || beforeAfterPictures!.isEmpty) {
      return false;
    }
    for (final detail in beforeAfterPictures!) {
      if (!detail.isComplete) return false;
    }
    return true;
  }
}

@JsonSerializable()
class BeforeAfterModel {
  BeforeAfterModel({
    required this.bodyPart,
    this.id,
    this.zones = const [],
  });

  factory BeforeAfterModel.fromJson(Map<String, dynamic> json) =>
      _$BeforeAfterModelFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String bodyPart;
  final List<Zone> zones;

  Map<String, dynamic> toJson() => _$BeforeAfterModelToJson(this);

  BeforeAfterModel copyWith({
    String? id,
    String? bodyPart,
    List<Zone>? zones,
  }) {
    return BeforeAfterModel(
      id: id ?? this.id,
      bodyPart: bodyPart ?? this.bodyPart,
      zones: zones ?? this.zones,
    );
  }

  bool get isComplete {
    if (bodyPart.isEmpty) return false;
    for (final zone in zones) {
      if (!zone.isComplete) return false;
    }
    return zones.isNotEmpty;
  }
}

@immutable
@JsonSerializable()
class Zone {
  const Zone({
    this.id,
    this.zone,
    this.beforeImageUrl,
    this.afterImageUrl,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String? zone;
  final String? beforeImageUrl;
  final String? afterImageUrl;

  Map<String, dynamic> toJson() => _$ZoneToJson(this);

  Zone copyWith({
    String? id,
    String? zone,
    String? beforeImageUrl,
    String? afterImageUrl,
  }) {
    return Zone(
      id: id ?? this.id,
      zone: zone ?? this.zone,
      beforeImageUrl: beforeImageUrl ?? this.beforeImageUrl,
      afterImageUrl: afterImageUrl ?? this.afterImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Zone &&
        other.zone == zone &&
        other.beforeImageUrl == beforeImageUrl &&
        other.afterImageUrl == afterImageUrl;
  }

  @override
  int get hashCode => Object.hash(zone, beforeImageUrl, afterImageUrl);

  bool get isComplete {
    if (zone == null || (zone?.isEmpty ?? true)) return false;
    final hasBefore = beforeImageUrl != null && beforeImageUrl!.isNotEmpty;
    final hasAfter = afterImageUrl != null && afterImageUrl!.isNotEmpty;
    return hasBefore && hasAfter;
  }
}

@JsonSerializable()
class PriceRange {
  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeFromJson(json);

  final num? min;
  final num? max;

  Map<String, dynamic> toJson() => _$PriceRangeToJson(this);

  PriceRange copyWith({
    num? min,
    num? max,
  }) {
    return PriceRange(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}

@JsonSerializable()
class Docs {
  Docs({required this.name, required this.link, this.id});

  factory Docs.fromJson(Map<String, dynamic> json) => _$DocsFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String link;

  Map<String, dynamic> toJson() => _$DocsToJson(this);

  Docs copyWith({
    String? id,
    String? name,
    String? link,
  }) {
    return Docs(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }
}
