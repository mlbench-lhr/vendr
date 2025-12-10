class ReviewsService {
  static String formatTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return "${m}m ago";
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return "${h}h ago";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return "$d day${d == 1 ? '' : 's'} ago";
    } else {
      // Format: 12 July 2025
      final date = createdAt;
      const months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      final day = date.day;
      final month = months[date.month - 1];
      final year = date.year;

      return "$day $month $year";
    }
  }
}
