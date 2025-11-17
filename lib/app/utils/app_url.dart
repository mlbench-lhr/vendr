class AppUrl {
  // Base URLs
  static const String baseUrl = 'http://web-novel-django.ml-bench.com';
  // static const String baseUrl = 'https://4znvw6hv-8082.inc1.devtunnels.ms';

  // ========================
  // Authentication Endpoints
  // ========================

  // User Auth
  static const String login = '$baseUrl/api/auth/login';
  static const String signup = '$baseUrl/api/auth/signup';
  static const String getMeUser = '$baseUrl/api/auth/me';
  static const String sendOtp = '$baseUrl/api/auth/send-otp';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static const String resetPassword = '$baseUrl/api/auth/reset-password';

  // Doctor Auth
  static const String doctorLogin = '$baseUrl/api/auth/doctor/login';
  static const String doctorSignup = '$baseUrl/api/auth/doctor/signup';
  static const String getMeDoctor = '$baseUrl/api/auth/doctor/me';
  static const String doctorSignupOtp = '$baseUrl/api/auth/doctor/signup-otp';
  static const String doctorVerifyOtp = '$baseUrl/api/auth/doctor/verify-otp';
  static const String doctorForgotPassword =
      '$baseUrl/api/auth/doctor/forgot-password';
  static const String doctorResendOtp = '$baseUrl/api/auth/doctor/resend-otp';
  static const String doctorResetPassword =
      '$baseUrl/api/auth/doctor/reset-password';
  static const String connectAccount =
      '$baseUrl/api/auth/doctor/connect_account';
  static const String withdrawMoney = '$baseUrl/api/auth/doctor/withdraw_money';
  static const String doctorChangePassword =
      '$baseUrl/api/auth/doctor/change-password';
  static const String doctorDeleteAccount =
      '$baseUrl/api/auth/doctor/delete-account';
  static String getAllProcedures(String locale) =>
      '$baseUrl/api/auth/doctor/procedures/?language=$locale';

  // ====================
  // Profile Endpoints
  // ====================

  // Doctor Profile
  static const String doctorProfile = '$baseUrl/api/auth/doctor/profile';
  static const String walletInfo = '$baseUrl/api/auth/doctor/wallet-info';

  // User Profile
  static const String userProfileUpdate = '$baseUrl/api/user/profile-update';
  static const String userUpdatePassword = '$baseUrl/api/user/update-password';
  static const String userDeleteAccount = '$baseUrl/api/user/delete-account';
  static const String userReportProblem = '$baseUrl/api/report-problem';

  // ====================
  // Home Endpoints
  // ====================

  // Doctor Home
  static const String doctorDashboardStats =
      '$baseUrl/api/doctor/home/dashboard-stats';
  static const String doctorEarningsGraph =
      '$baseUrl/api/doctor/home/earnings-graph';
  static const String doctorLikesGraph =
      '$baseUrl/api/doctor/home/doctor-likes-graph';
  static const String doctorImpressions =
      '$baseUrl/api/doctor/home/get-doctor-impressions';

  // User Home
  static const String userDoctors = '$baseUrl/api/user/home/doctors';
  static const String userSearchDoctors =
      '$baseUrl/api/user/home/doctors/search';
  static const String userDoctorOpinion =
      '$baseUrl/api/user/home/medical-opinion';
  static const String userBookingLinkClicked =
      '$baseUrl/api/user/home/bookingClick';
  static String userLikeDoctor(String doctorId) =>
      '$baseUrl/api/user/home/doctors/$doctorId/like';
  static String userDoctorDetails(String doctorId) =>
      '$baseUrl/api/user/home/doctors_details?doctorId=$doctorId';
  static String userDoctorReviews(String doctorId) =>
      '$baseUrl/api/home/doctors/$doctorId/reviews';

  static const String userDoctorsInfoForMap =
      '$baseUrl/api/user/home/doctors/filtered';

  // ===========================
  // Medical Opinion Endpoints
  // ===========================

  // Doctor Medical Opinion
  static const String doctorMedicalOpinions =
      '$baseUrl/api/doctor/medical-opinion/get-user-medical-opinions';
  static const String doctorMedicalOpinionResponse =
      '$baseUrl/api/doctor/medical-opinion/give-response';
  static String doctorMedicalOpinionDetails(String opinionId) =>
      '$baseUrl/api/doctor/medical-opinion/get-medical-opinions-details/$opinionId';

  // User Medical Opinion
  static const String userMedicalOpinions =
      '$baseUrl/api/user/medical-opinion/get-user-medical-opinions';
  static String userMedicalOpinionDetails(String opinionId) =>
      '$baseUrl/api/user/medical-opinion/get-medical-opinions-details/$opinionId';
  static const String userMedicalOpinionFeedback =
      '$baseUrl/api/user/medical-opinion/give-feedback';
  //Payment
  static const String medicalOpinionPaymentIntent =
      '$baseUrl/api/user/medical-opinion/get_payment_intent';
  static const String confirmMedicalOpinionPayment =
      '$baseUrl/api/user/medical-opinion/confirmPayment';

  // ====================
  // Notifications Endpoints
  // ====================
  static const String saveTokenDoctor =
      '$baseUrl/api/doctor/medical-opinion/save-token';
  static const String saveTokenUser =
      '$baseUrl/api/user/medical-opinion/save-token';
  static const String pushNotificationUser =
      '$baseUrl/api/user/medical-opinion/push-notification';
  static const String pushNotificationDoctor =
      '$baseUrl/api/doctor/medical-opinion/push-notification';

  // ====================
  // Review Endpoints
  // ====================
  static const String doctorHideReview =
      '$baseUrl/api/doctor/review/hide-review';

  // ====================
  // Subscription & Payments
  // ====================
  static const String subscriptionHistory =
      '$baseUrl/api/subscription/get-subscription-history';
  static const String createSubscription = '$baseUrl/api/subscription/create';
  static const String createSubscriptionIntent =
      '$baseUrl/api/subscription/create-payment-intent';
  static const String subscriptionPlans = '$baseUrl/api/subscription/plans';
  static const String cancelSubscription = '$baseUrl/api/subscription/cancel';
  // Pay as you go
  static const String clicksPurchaseIntent =
      '$baseUrl/api/subscription/purchase-clicks';
  static const String confirmClicksPurchase =
      '$baseUrl/api/subscription/confirm-click-purchase';

  // ====================
  // Upload Endpoints
  // ====================
  static const String uploadImage = '$baseUrl/api/upload/image';
  static const String uploadDoc = '$baseUrl/api/upload/upload-docs';

  // ====================
  // AI Endpoints
  // ====================
  static const String aiSuggestions = 'http://143.198.238.226:8000/suggest';
}
