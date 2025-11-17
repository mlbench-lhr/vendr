// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponse _$ReviewResponseFromJson(Map<String, dynamic> json) =>
    ReviewResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ReviewData.fromJson(e as Map<String, dynamic>))
          .toList(),
      avgRating: (json['avgRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      ratingCounts: Map<String, int>.from(json['ratingCounts'] as Map),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ReviewResponseToJson(ReviewResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'avgRating': instance.avgRating,
      'totalReviews': instance.totalReviews,
      'ratingCounts': instance.ratingCounts,
      'pagination': instance.pagination,
    };

ReviewData _$ReviewDataFromJson(Map<String, dynamic> json) => ReviewData(
  hidden: json['hidden'] as bool,
  id: json['_id'] as String,
  userId: UserId.fromJson(json['userId'] as Map<String, dynamic>),
  doctorId: json['doctorId'] as String,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  v: (json['__v'] as num?)?.toInt(),
  opinionId: json['opinionId'] as String?,
);

Map<String, dynamic> _$ReviewDataToJson(ReviewData instance) =>
    <String, dynamic>{
      'hidden': instance.hidden,
      '_id': instance.id,
      'userId': instance.userId,
      'doctorId': instance.doctorId,
      'opinionId': instance.opinionId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
    };

UserId _$UserIdFromJson(Map<String, dynamic> json) => UserId(
  id: json['_id'] as String,
  userName: json['userName'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$UserIdToJson(UserId instance) => <String, dynamic>{
  '_id': instance.id,
  'userName': instance.userName,
  'image': instance.image,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  current: (json['current'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current': instance.current,
      'pages': instance.pages,
      'total': instance.total,
    };
