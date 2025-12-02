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
  static const String verifyVendorOtp =
      '$baseUrl/auth/vendor/signup'; //verify otp to complete signup
  static const String verifyUserOtp =
      '$baseUrl/auth/user/signup'; //verify otp to complete signup
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  static const String vendorLogin = '$baseUrl/auth/vendor/login';
  static const String userLogin = '$baseUrl/auth/user/login';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
}
