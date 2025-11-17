// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  id: json['_id'] as String?,
  bio: json['bio'] as String?,
  experience: (json['experience'] as num?)?.toInt(),
  location: json['location'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  specializations: (json['specializations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  brandTechnique: (json['brandTechnique'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  medicalSpecialty: (json['medicalSpecialty'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  procedures: (json['procedures'] as List<dynamic>?)
      ?.map((e) => ProcedureModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  verificationDocs: (json['verificationDocs'] as List<dynamic>?)
      ?.map((e) => Docs.fromJson(e as Map<String, dynamic>))
      .toList(),
  image: json['image'] as String?,
  clinicImage: json['clinicImage'] as String?,
  clinicName: json['clinicName'] as String?,
  verified: (json['verified'] as num?)?.toInt(),
  medicalOpinionRequest: json['medicalOpinionRequest'] as bool? ?? false,
  bookingLink: json['bookingLink'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  isLiked: json['isLiked'] as bool?,
  distance: (json['distance'] as num?)?.toDouble(),
  emailVerified: json['emailVerified'] as bool?,
  totalClicks: (json['total_clicks'] as num?)?.toInt(),
  clicksLeft: (json['clicks_left'] as num?)?.toInt(),
  isSubscribed: json['isSubscribed'] as bool?,
  subscriptionType: json['subscriptionType'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  rejectedAt: json['rejectedAt'] == null
      ? null
      : DateTime.parse(json['rejectedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  stripeCustomerId: json['stripeCustomerId'] as String?,
  stripeAccountId: json['stripeAccountId'] as String?,
  withdrawable: (json['withdrawable'] as num?)?.toInt(),
  totalEarnings: (json['total_earning'] as num?)?.toInt(),
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'bio': instance.bio,
      'experience': instance.experience,
      'location': instance.location,
      'lat': instance.lat,
      'lng': instance.lng,
      'rating': instance.rating,
      'isLiked': instance.isLiked,
      'distance': instance.distance,
      'specializations': instance.specializations,
      'brandTechnique': instance.brandTechnique,
      'medicalSpecialty': instance.medicalSpecialty,
      'procedures': instance.procedures?.map((e) => e.toJson()).toList(),
      'verificationDocs': instance.verificationDocs
          ?.map((e) => e.toJson())
          .toList(),
      'image': instance.image,
      'clinicImage': instance.clinicImage,
      'clinicName': instance.clinicName,
      'verified': instance.verified,
      'medicalOpinionRequest': instance.medicalOpinionRequest,
      'bookingLink': instance.bookingLink,
      'emailVerified': instance.emailVerified,
      'isSubscribed': instance.isSubscribed,
      'subscriptionType': instance.subscriptionType,
      'rejectionReason': instance.rejectionReason,
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'stripeCustomerId': instance.stripeCustomerId,
      'stripeAccountId': instance.stripeAccountId,
      'withdrawable': instance.withdrawable,
      'total_earning': instance.totalEarnings,
      'total_clicks': instance.totalClicks,
      'clicks_left': instance.clicksLeft,
    };

ProcedureModel _$ProcedureModelFromJson(Map<String, dynamic> json) =>
    ProcedureModel(
      procedureType: json['procedureType'] as String,
      id: json['_id'] as String?,
      currency: json['currency'] as String?,
      priceRange: json['priceRange'] == null
          ? null
          : PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
      beforeAfterPictures: (json['beforeAfterPictures'] as List<dynamic>?)
          ?.map((e) => BeforeAfterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProcedureModelToJson(ProcedureModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'procedureType': instance.procedureType,
      'currency': instance.currency,
      'priceRange': instance.priceRange?.toJson(),
      'beforeAfterPictures': instance.beforeAfterPictures
          ?.map((e) => e.toJson())
          .toList(),
    };

BeforeAfterModel _$BeforeAfterModelFromJson(Map<String, dynamic> json) =>
    BeforeAfterModel(
      bodyPart: json['bodyPart'] as String,
      id: json['_id'] as String?,
      zones:
          (json['zones'] as List<dynamic>?)
              ?.map((e) => Zone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BeforeAfterModelToJson(BeforeAfterModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'bodyPart': instance.bodyPart,
      'zones': instance.zones,
    };

Zone _$ZoneFromJson(Map<String, dynamic> json) => Zone(
  id: json['_id'] as String?,
  zone: json['zone'] as String?,
  beforeImageUrl: json['beforeImageUrl'] as String?,
  afterImageUrl: json['afterImageUrl'] as String?,
);

Map<String, dynamic> _$ZoneToJson(Zone instance) => <String, dynamic>{
  '_id': instance.id,
  'zone': instance.zone,
  'beforeImageUrl': instance.beforeImageUrl,
  'afterImageUrl': instance.afterImageUrl,
};

PriceRange _$PriceRangeFromJson(Map<String, dynamic> json) =>
    PriceRange(min: json['min'] as num?, max: json['max'] as num?);

Map<String, dynamic> _$PriceRangeToJson(PriceRange instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

Docs _$DocsFromJson(Map<String, dynamic> json) => Docs(
  name: json['name'] as String,
  link: json['link'] as String,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$DocsToJson(Docs instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'link': instance.link,
};
