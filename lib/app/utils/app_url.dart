class AppUrl {
  // Base URLs
  static const String baseUrl = 'http://vendr.ml-bench.com/api';

  // ========================
  // Authentication Endpoints
  // ========================

  // User Auth
  // static const String login = '$baseUrl/api/auth/login';
  static const String vendorSignup =
      '$baseUrl/auth/vendor/signup-otp'; //add info and send otp
  static const String userSignup =
      '$baseUrl/auth/user/signup-otp'; //add info and send otp
  static const String userOAuth =
      '$baseUrl/auth/user/oauth'; //user google or apple auth
  static const String vendorOAuth =
      '$baseUrl/auth/vendor/oauth'; //vendor google or apple auth
  static const String verifyVendorOtp =
      '$baseUrl/auth/vendor/signup'; //verify otp to complete signup
  static const String verifyUserOtp =
      '$baseUrl/auth/user/signup'; //verify otp to complete signup
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';

  static const String vendorLogin = '$baseUrl/auth/vendor/login';
  static const String userLogin = '$baseUrl/auth/user/login';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  static const String deleteVendorAccount =
      '$baseUrl/auth/vendor/delete-account';
  // Delete User Account
  static const String deleteUserAccount = '$baseUrl/auth/user/delete-account';

  // ========================
  // Home Endpoints
  // ========================
  static const String getNearbyVendors = '$baseUrl/auth/user/nearby-vendors';

  static String getVendorDetails(String vendorId) =>
      '$baseUrl/auth/vendor/$vendorId/details';
  static String getVendorReviewsById(String vendorId) =>
      '$baseUrl/auth/reviews/$vendorId';

  static const String addToFavorites = '$baseUrl/auth/add-favorite';

  // ========================
  // Profile Endpoints
  // ========================
  static const String getVendorProfile = '$baseUrl/auth/vendor/profile';
  static const String getUserProfile = '$baseUrl/auth/user/profile';
  static const String vendorProfileUpdate = '$baseUrl/auth/vendor/edit-profile';
  static const String userProfileUpdate = '$baseUrl/auth/user/edit-profile';
  static const String vendorHoursUpdate = '$baseUrl/auth/vendor/hours';
  static const String uploadProduct = '$baseUrl/auth/vendor/menu/upload';
  static const String deleteProduct = '$baseUrl/auth/vendor/menu';
  static const String getVendorReviews = '$baseUrl/auth/vendor/reviews';
  static const String addUserReview = '$baseUrl/auth/reviews';
  static const String searchVendors = '$baseUrl/auth/vendors/search';
  static const String getNotifications = '$baseUrl/auth/notifications';
  static const String editProduct =
      '$baseUrl/auth/vendor/menu/edit/'; // $baseUrl/auth/vendor/menu/edit/productId

  static const String removeFromFavorites = '$baseUrl/auth/remove-favorite';

  // ========================
  // Upload Endpoints
  // ========================
  static const String uploadImage = '$baseUrl/auth/image';

  // ====================
  // Notifications Endpoints //TODO: Update endpoints
  // ====================
  static const String saveTokenVendor = '$baseUrl/auth/vendor/save-token';
  static const String saveTokenUser = '$baseUrl/auth/user/save-token';
  static const String pushNotificationUser =
      '$baseUrl/auth/user/push-notification'; //Not implemented on backend
  static const String pushNotificationVendor =
      '$baseUrl/auth/vendor/push-notification'; //Not implemented on backend
}
