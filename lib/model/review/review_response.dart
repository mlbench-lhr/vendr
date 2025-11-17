import 'package:json_annotation/json_annotation.dart';

part 'review_response.g.dart';

@JsonSerializable()
class ReviewResponse {
  ReviewResponse({
    required this.success,
    required this.data,
    required this.avgRating,
    required this.totalReviews,
    required this.ratingCounts,
    required this.pagination,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);

  final bool success;
  final List<ReviewData> data;
  final double avgRating; // Changed to double
  final int totalReviews;
  final Map<String, int> ratingCounts;
  final Pagination pagination;

  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);
}

@JsonSerializable()
class ReviewData {
  ReviewData({
    required this.hidden,
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.v,
    this.opinionId,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) =>
      _$ReviewDataFromJson(json);

  final bool hidden; // Added field
  @JsonKey(name: '_id')
  final String id;
  final UserId userId;
  final String doctorId;
  final String? opinionId;
  final double rating; // Changed to double
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final int? v;

  Map<String, dynamic> toJson() => _$ReviewDataToJson(this);
}

@JsonSerializable()
class UserId {
  UserId({
    required this.id,
    required this.userName,
    this.image,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String userName; // Replaced firstName/lastName
  final String? image;

  Map<String, dynamic> toJson() => _$UserIdToJson(this);
}

@JsonSerializable()
class Pagination {
  Pagination({
    required this.current,
    required this.pages,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  final int current;
  final int pages;
  final int total;

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
