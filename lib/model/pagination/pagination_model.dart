class PaginationModel {
  PaginationModel({
    required this.current,
    required this.pages,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      current: json['current'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
  final int current;
  final int pages;
  final int total;
}
