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
  static const String verifyOtp =
      '$baseUrl/auth/vendor/signup'; //verify otp to complete signup

  static const String vendorLogin = '';
  static const String userLogin = '';
  static const String userSignup = '';
}
