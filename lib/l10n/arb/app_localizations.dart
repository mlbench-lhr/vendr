import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get not_available;

  /// No description provided for @opinion_response_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a response'**
  String get opinion_response_required;

  /// No description provided for @error_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get error_email_required;

  /// No description provided for @error_no_link_allowed.
  ///
  /// In en, this message translates to:
  /// **'No Link is allowed'**
  String get error_no_link_allowed;

  /// No description provided for @error_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get error_email_invalid;

  /// No description provided for @error_stripe_id_required.
  ///
  /// In en, this message translates to:
  /// **'Stripe Id is required.'**
  String get error_stripe_id_required;

  /// No description provided for @error_stripe_id_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid stripe Id.'**
  String get error_stripe_id_invalid;

  /// No description provided for @error_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get error_password_required;

  /// No description provided for @error_password_same_as_old.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from old password'**
  String get error_password_same_as_old;

  /// No description provided for @error_password_strength.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter, one number, and one special character.'**
  String get error_password_strength;

  /// No description provided for @error_clinic_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name must contain only alphabets and spaces.'**
  String get error_clinic_name_invalid;

  /// No description provided for @error_first_name_required.
  ///
  /// In en, this message translates to:
  /// **'First Name is required.'**
  String get error_first_name_required;

  /// No description provided for @error_first_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'First Name must contain only alphabets and spaces.'**
  String get error_first_name_invalid;

  /// No description provided for @error_last_name_required.
  ///
  /// In en, this message translates to:
  /// **'Last Name is required.'**
  String get error_last_name_required;

  /// No description provided for @error_last_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Last Name must contain only alphabets and spaces.'**
  String get error_last_name_invalid;

  /// No description provided for @error_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get error_name_required;

  /// No description provided for @error_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Name must contain only alphabets and spaces.'**
  String get error_name_invalid;

  /// No description provided for @error_address_required.
  ///
  /// In en, this message translates to:
  /// **'Address is required.'**
  String get error_address_required;

  /// No description provided for @error_address_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please provide correct address'**
  String get error_address_invalid;

  /// No description provided for @error_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required.'**
  String get error_confirm_password_required;

  /// No description provided for @error_confirm_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password does not match Password.'**
  String get error_confirm_password_mismatch;

  /// No description provided for @error_date_of_birth_required.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get error_date_of_birth_required;

  /// No description provided for @error_date_in_future.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be in future'**
  String get error_date_in_future;

  /// No description provided for @error_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get error_password_mismatch;

  /// No description provided for @dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialog_cancel;

  /// No description provided for @dialog_yes_delete.
  ///
  /// In en, this message translates to:
  /// **'Yes Delete'**
  String get dialog_yes_delete;

  /// No description provided for @dialog_delete_acc.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get dialog_delete_acc;

  /// No description provided for @dialog_delete_acc_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? you will lost all your data and you couldn\'t restore this later'**
  String get dialog_delete_acc_subtitle;

  /// No description provided for @sheet_verify_email_address.
  ///
  /// In en, this message translates to:
  /// **'Verify Email Address'**
  String get sheet_verify_email_address;

  /// No description provided for @sheet_enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP that we have sent on your given email address'**
  String get sheet_enter_otp;

  /// No description provided for @sheet_resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get sheet_resend_otp;

  /// No description provided for @sheet_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get sheet_verify;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Esthetic Match'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover top-rated aesthetic practitioners near you — tailored to your beauty goals.'**
  String get welcome_subtitle;

  /// No description provided for @welcome_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get welcome_no_account;

  /// No description provided for @welcome_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get welcome_signup;

  /// No description provided for @welcome_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get welcome_login;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login To Esthetic Match'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to esthetic match with your account credentials'**
  String get login_subtitle;

  /// No description provided for @login_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get login_email_label;

  /// No description provided for @login_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get login_email_hint;

  /// No description provided for @login_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password_label;

  /// No description provided for @login_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get login_password_hint;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get login_forgot_password;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @login_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get login_no_account;

  /// No description provided for @login_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_signup;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'SignUp To Esthetic Match'**
  String get signup_title;

  /// No description provided for @signup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account  to esthetic match by adding your account details'**
  String get signup_subtitle;

  /// No description provided for @signup_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get signup_username;

  /// No description provided for @signup_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get signup_first_name;

  /// No description provided for @signup_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get signup_last_name;

  /// No description provided for @signup_username_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get signup_username_hint;

  /// No description provided for @signup_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get signup_email_address;

  /// No description provided for @signup_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Your email'**
  String get signup_email_hint;

  /// No description provided for @signup_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get signup_dob;

  /// No description provided for @signup_dob_hint.
  ///
  /// In en, this message translates to:
  /// **'Select your DOB'**
  String get signup_dob_hint;

  /// No description provided for @signup_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get signup_location;

  /// No description provided for @signup_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get signup_address_hint;

  /// No description provided for @signup_zone_hint.
  ///
  /// In en, this message translates to:
  /// **'Select Zone'**
  String get signup_zone_hint;

  /// No description provided for @signup_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender '**
  String get signup_gender;

  /// No description provided for @signup_optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get signup_optional;

  /// No description provided for @signup_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signup_password;

  /// No description provided for @signup_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get signup_password_hint;

  /// No description provided for @signup_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signup_confirm_password;

  /// No description provided for @signup_btn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_btn;

  /// No description provided for @signup_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signup_login;

  /// No description provided for @signup_terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get signup_terms_conditions;

  /// No description provided for @signup_agree_to_our.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our '**
  String get signup_agree_to_our;

  /// No description provided for @signup_already_have_acc.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signup_already_have_acc;

  /// No description provided for @signup_file_limit_reached.
  ///
  /// In en, this message translates to:
  /// **'You have reached them maximum limit'**
  String get signup_file_limit_reached;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @forgot_dont_worry.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Worry!! it happens just enter your email address so that we can verify yourself'**
  String get forgot_dont_worry;

  /// No description provided for @forgot_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get forgot_email_address;

  /// No description provided for @forgot_enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get forgot_enter_your_email;

  /// No description provided for @forgot_send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get forgot_send_otp;

  /// No description provided for @forgot_resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get forgot_resend_otp;

  /// No description provided for @forgot_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get forgot_verify;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @reset_enter_your_new_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password, so that you can access your account.'**
  String get reset_enter_your_new_password_subtitle;

  /// No description provided for @reset_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get reset_enter_password;

  /// No description provided for @reset_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get reset_confirm_password;

  /// No description provided for @reset_reset_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get reset_reset_continue;

  /// No description provided for @acc_type_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Account Type'**
  String get acc_type_title;

  /// No description provided for @acc_type_doc_title.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Provider'**
  String get acc_type_doc_title;

  /// No description provided for @acc_type_doc_subtitle.
  ///
  /// In en, this message translates to:
  /// **'(Doctor, Surgeon, Aesthetic Practitioner)'**
  String get acc_type_doc_subtitle;

  /// No description provided for @acc_type_user_title.
  ///
  /// In en, this message translates to:
  /// **'Patient or Visitor'**
  String get acc_type_user_title;

  /// No description provided for @acc_type_user_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for treatments or information'**
  String get acc_type_user_subtitle;

  /// No description provided for @acc_type_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get acc_type_english;

  /// No description provided for @acc_type_french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get acc_type_french;

  /// No description provided for @step2_medical_specialty.
  ///
  /// In en, this message translates to:
  /// **'Medical Specialty'**
  String get step2_medical_specialty;

  /// No description provided for @step2_select_medical_specialty.
  ///
  /// In en, this message translates to:
  /// **'Select Medical Specialty'**
  String get step2_select_medical_specialty;

  /// No description provided for @step2_select_specialization.
  ///
  /// In en, this message translates to:
  /// **'Select Specialization'**
  String get step2_select_specialization;

  /// No description provided for @step2_select_techniques_and_brands.
  ///
  /// In en, this message translates to:
  /// **'Select Techniques & Brands'**
  String get step2_select_techniques_and_brands;

  /// No description provided for @step2_tell_us_about_yourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us About Yourself!!'**
  String get step2_tell_us_about_yourself;

  /// No description provided for @step2_please_enter_your_profile.
  ///
  /// In en, this message translates to:
  /// **'Please enter your profile details so that we get to know you better.'**
  String get step2_please_enter_your_profile;

  /// No description provided for @step2_bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get step2_bio;

  /// No description provided for @step2_about_yourself.
  ///
  /// In en, this message translates to:
  /// **'About Yourself (Optional)'**
  String get step2_about_yourself;

  /// No description provided for @step2_experience.
  ///
  /// In en, this message translates to:
  /// **'Experience '**
  String get step2_experience;

  /// No description provided for @step2_experience_years.
  ///
  /// In en, this message translates to:
  /// **'(Years)'**
  String get step2_experience_years;

  /// No description provided for @step2_clinic_name.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get step2_clinic_name;

  /// No description provided for @step2_enter_clinic_name.
  ///
  /// In en, this message translates to:
  /// **'Enter clinic name (Optional)'**
  String get step2_enter_clinic_name;

  /// No description provided for @step2_enter_clinic_location.
  ///
  /// In en, this message translates to:
  /// **'Enter clinic location'**
  String get step2_enter_clinic_location;

  /// No description provided for @step2_clinic_location.
  ///
  /// In en, this message translates to:
  /// **'Clinic Location*'**
  String get step2_clinic_location;

  /// No description provided for @step2_add_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Add Booking Link'**
  String get step2_add_booking_link;

  /// No description provided for @step2_add_booking_link_subtext.
  ///
  /// In en, this message translates to:
  /// **'Add an external link (like Calendly) so clients can book appointments with you directly.'**
  String get step2_add_booking_link_subtext;

  /// No description provided for @step2_link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get step2_link;

  /// No description provided for @step2_top_procedures_specialized.
  ///
  /// In en, this message translates to:
  /// **'Top 3 procedures/ Specialized'**
  String get step2_top_procedures_specialized;

  /// No description provided for @step2_select_multiple_options.
  ///
  /// In en, this message translates to:
  /// **'Select Multiple Options'**
  String get step2_select_multiple_options;

  /// No description provided for @step2_add_clinic_photo.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of clinic'**
  String get step2_add_clinic_photo;

  /// No description provided for @step2_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get step2_next;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get nav_activity;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @nav_medical_opinion.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion'**
  String get nav_medical_opinion;

  /// No description provided for @nav_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get nav_reviews;

  /// No description provided for @add_doc_title.
  ///
  /// In en, this message translates to:
  /// **'Verification Documents'**
  String get add_doc_title;

  /// No description provided for @add_doc_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your medical license and specialization documents for verification. You can upload up to 3 documents (pdf). You can also view your uploaded documents by selecting them below.'**
  String get add_doc_subtitle;

  /// No description provided for @add_doc_add_document.
  ///
  /// In en, this message translates to:
  /// **'Add Documents'**
  String get add_doc_add_document;

  /// No description provided for @add_doc_no_document.
  ///
  /// In en, this message translates to:
  /// **'No Document'**
  String get add_doc_no_document;

  /// No description provided for @add_doc_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get add_doc_done;

  /// No description provided for @add_doc_files_count.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get add_doc_files_count;

  /// No description provided for @add_doc_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get add_doc_uploaded;

  /// Error message when user tries to upload more files than allowed
  ///
  /// In en, this message translates to:
  /// **'Only {availableSlots} more files can be added (limit: {limit} total)'**
  String common_file_upload_limit_error(int availableSlots, int limit);

  /// Error message when a file with the same name already exists in upload list
  ///
  /// In en, this message translates to:
  /// **'File \"{fileName}\" already exists'**
  String add_doc_file_already_exists_error(String fileName);

  /// No description provided for @add_doc_wait_for_uploads.
  ///
  /// In en, this message translates to:
  /// **'Please wait for all files to finish uploading'**
  String get add_doc_wait_for_uploads;

  /// No description provided for @add_doc_some_files_failed.
  ///
  /// In en, this message translates to:
  /// **'Some files failed to upload. Please try again or remove them.'**
  String get add_doc_some_files_failed;

  /// Status message showing counts of uploading and uploaded files
  ///
  /// In en, this message translates to:
  /// **'Uploading: {uploadingFilesCount}, Uploaded: {uploadedFilesCount}'**
  String add_doc_uploading_status(
      int uploadingFilesCount, int uploadedFilesCount);

  /// No description provided for @add_doc_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get add_doc_uploading;

  /// No description provided for @add_doc_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get add_doc_upload_failed;

  /// No description provided for @add_doc_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get add_doc_selected;

  /// Label showing the size of a file in KB
  ///
  /// In en, this message translates to:
  /// **' • {fileSize} KB'**
  String add_doc_file_size(String fileSize);

  /// No description provided for @add_doc_retry_upload.
  ///
  /// In en, this message translates to:
  /// **'Retry upload'**
  String get add_doc_retry_upload;

  /// No description provided for @acc_verify_rejected_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Verification Request Rejected!!'**
  String get acc_verify_rejected_title;

  /// No description provided for @acc_verify_rejected_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to inform you that your request to become a Practitioner has been rejected'**
  String get acc_verify_rejected_subtitle;

  /// No description provided for @acc_verify_rejected_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get acc_verify_rejected_reason;

  /// No description provided for @acc_verify_not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get acc_verify_not_available;

  /// No description provided for @acc_verify_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get acc_verify_try_again;

  /// No description provided for @before_after_title.
  ///
  /// In en, this message translates to:
  /// **'Before/After Pictures'**
  String get before_after_title;

  /// No description provided for @before_after_before_treatment.
  ///
  /// In en, this message translates to:
  /// **'Before Treatment'**
  String get before_after_before_treatment;

  /// No description provided for @before_after_after_treatment.
  ///
  /// In en, this message translates to:
  /// **'After Treatment'**
  String get before_after_after_treatment;

  /// No description provided for @user_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get user_edit_profile;

  /// No description provided for @user_edit_profile_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get user_edit_profile_last_name;

  /// No description provided for @user_edit_profile_enter_your_last_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Last Name'**
  String get user_edit_profile_enter_your_last_name;

  /// No description provided for @user_edit_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get user_edit_profile_name;

  /// No description provided for @user_edit_profile_enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get user_edit_profile_enter_your_name;

  /// No description provided for @user_edit_profile_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get user_edit_profile_date_of_birth;

  /// No description provided for @user_edit_profile_select_your_dob.
  ///
  /// In en, this message translates to:
  /// **'Select your dob'**
  String get user_edit_profile_select_your_dob;

  /// No description provided for @user_edit_profile_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get user_edit_profile_location;

  /// No description provided for @user_edit_profile_enter_your_location.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Location'**
  String get user_edit_profile_enter_your_location;

  /// No description provided for @user_edit_profile_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get user_edit_profile_gender;

  /// No description provided for @user_edit_profile_optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get user_edit_profile_optional;

  /// No description provided for @user_edit_profile_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get user_edit_profile_update;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @change_old_password.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get change_old_password;

  /// No description provided for @change_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get change_new_password;

  /// No description provided for @change_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get change_confirm_password;

  /// No description provided for @change_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get change_enter_password;

  /// No description provided for @change_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get change_update;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit_profile;

  /// No description provided for @profile_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_change_password;

  /// No description provided for @profile_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get profile_subscription;

  /// No description provided for @profile_procedure_pricing.
  ///
  /// In en, this message translates to:
  /// **'Procedures & Pricing'**
  String get profile_procedure_pricing;

  /// No description provided for @profile_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Booking Link'**
  String get profile_booking_link;

  /// No description provided for @profile_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Add payment Method'**
  String get profile_payment_method;

  /// No description provided for @profile_documents.
  ///
  /// In en, this message translates to:
  /// **'Add Documents'**
  String get profile_documents;

  /// No description provided for @profile_medical_opinion_request.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion Request'**
  String get profile_medical_opinion_request;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profile_terms_conditions;

  /// No description provided for @profile_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profile_privacy_policy;

  /// No description provided for @profile_report_problem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get profile_report_problem;

  /// No description provided for @profile_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profile_delete_account;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settings_language;

  /// No description provided for @booking_link_title.
  ///
  /// In en, this message translates to:
  /// **'Add Booking Link'**
  String get booking_link_title;

  /// No description provided for @booking_link_enter_link.
  ///
  /// In en, this message translates to:
  /// **'Enter link'**
  String get booking_link_enter_link;

  /// No description provided for @booking_link_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get booking_link_update;

  /// No description provided for @booking_link_info.
  ///
  /// In en, this message translates to:
  /// **'You can add one link for contact or online booking — such as your clinic\'s website, Calendly, Doctolib, or any other scheduling tool you use.'**
  String get booking_link_info;

  /// No description provided for @booking_link_url_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL.'**
  String get booking_link_url_required;

  /// No description provided for @booking_link_invalid_url.
  ///
  /// In en, this message translates to:
  /// **'The URL you entered is invalid. Please check and try again.'**
  String get booking_link_invalid_url;

  /// No description provided for @home_find_your_ideal_practitioner.
  ///
  /// In en, this message translates to:
  /// **'Find your ideal practitioner'**
  String get home_find_your_ideal_practitioner;

  /// No description provided for @home_instruction_1.
  ///
  /// In en, this message translates to:
  /// **'Swipe right to like a practitioner.'**
  String get home_instruction_1;

  /// No description provided for @home_instruction_2.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to pass.'**
  String get home_instruction_2;

  /// No description provided for @home_instruction_3.
  ///
  /// In en, this message translates to:
  /// **'Tap on a profile for details.'**
  String get home_instruction_3;

  /// No description provided for @home_instruction_4.
  ///
  /// In en, this message translates to:
  /// **'Use filters to narrow results.'**
  String get home_instruction_4;

  /// No description provided for @home_your_profile_matches.
  ///
  /// In en, this message translates to:
  /// **'Your Profile Matches'**
  String get home_your_profile_matches;

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search doctors...'**
  String get home_search_hint;

  /// No description provided for @home_no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get home_no_results_found;

  /// Greeting with the user's name.
  ///
  /// In en, this message translates to:
  /// **'Hey {userName}'**
  String home_hey(String userName);

  /// No description provided for @home_no_practitioner_matches_searching.
  ///
  /// In en, this message translates to:
  /// **'Oops, No Practitioner Matches\nFound!!'**
  String get home_no_practitioner_matches_searching;

  /// No description provided for @home_no_practitioner_matches.
  ///
  /// In en, this message translates to:
  /// **'Oops, No Practitioner Matches'**
  String get home_no_practitioner_matches;

  /// No description provided for @home_no_doctors_to_display.
  ///
  /// In en, this message translates to:
  /// **'No doctors to display.'**
  String get home_no_doctors_to_display;

  /// Message showing the number of search results found.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No results found} =1 {1 result found} other {{count} results found}}'**
  String home_results_found(int count);

  /// No description provided for @error_please_describe_your_condition.
  ///
  /// In en, this message translates to:
  /// **'Please describe your condition...'**
  String get error_please_describe_your_condition;

  /// No description provided for @filters_procedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get filters_procedures;

  /// No description provided for @filters_techniques.
  ///
  /// In en, this message translates to:
  /// **'Techniques / Brands'**
  String get filters_techniques;

  /// No description provided for @filters_filter.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters_filter;

  /// No description provided for @filters_describe_your_condition.
  ///
  /// In en, this message translates to:
  /// **'What would you like to improve or which procedure are you looking for?'**
  String get filters_describe_your_condition;

  /// No description provided for @filters_describe_your_condition_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., I am concerned with my sagging neck...'**
  String get filters_describe_your_condition_hint;

  /// No description provided for @filters_ai_suggested_procedures.
  ///
  /// In en, this message translates to:
  /// **'AI Suggested Procedures'**
  String get filters_ai_suggested_procedures;

  /// No description provided for @filters_no_relevant_procedures_found.
  ///
  /// In en, this message translates to:
  /// **'No relevant procedures found.'**
  String get filters_no_relevant_procedures_found;

  /// No description provided for @filters_ai_search.
  ///
  /// In en, this message translates to:
  /// **'AI Search'**
  String get filters_ai_search;

  /// No description provided for @filters_distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get filters_distance;

  /// No description provided for @filters_select_procedures.
  ///
  /// In en, this message translates to:
  /// **'Select Procedures'**
  String get filters_select_procedures;

  /// No description provided for @filters_select_technqiues.
  ///
  /// In en, this message translates to:
  /// **'Select Techniques / Brands'**
  String get filters_select_technqiues;

  /// No description provided for @filters_manual_search.
  ///
  /// In en, this message translates to:
  /// **'Manual Search'**
  String get filters_manual_search;

  /// No description provided for @filters_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filters_apply;

  /// No description provided for @filters_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get filters_reset;

  /// No description provided for @filters_show_only_top_3.
  ///
  /// In en, this message translates to:
  /// **'Show only practitioners where suggested treatments are in top 3 expertise'**
  String get filters_show_only_top_3;

  /// Displays distance in kilometers.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String filters_distance_km(int distance);

  /// No description provided for @request_title.
  ///
  /// In en, this message translates to:
  /// **'Request Medical Opinion'**
  String get request_title;

  /// No description provided for @request_info.
  ///
  /// In en, this message translates to:
  /// **'This is not a medical consultation request but an online medical opinion request.'**
  String get request_info;

  /// No description provided for @request_for.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion For?'**
  String get request_for;

  /// No description provided for @request_for_hint.
  ///
  /// In en, this message translates to:
  /// **'Select a procedure'**
  String get request_for_hint;

  /// No description provided for @request_upload_photos.
  ///
  /// In en, this message translates to:
  /// **'Upload 1 - 3 Photos*'**
  String get request_upload_photos;

  /// No description provided for @request_additional_note.
  ///
  /// In en, this message translates to:
  /// **'Additional Note*'**
  String get request_additional_note;

  /// No description provided for @request_additional_note_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter here...'**
  String get request_additional_note_hint;

  /// No description provided for @request_charges.
  ///
  /// In en, this message translates to:
  /// **'Total Charges'**
  String get request_charges;

  /// No description provided for @request_pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get request_pay;

  /// No description provided for @request_consent_title.
  ///
  /// In en, this message translates to:
  /// **'Consent for Data Processing'**
  String get request_consent_title;

  /// No description provided for @request_consent.
  ///
  /// In en, this message translates to:
  /// **'I explicitly consent to Esthetic Match pfrocessing my photographs and health-related information for the purpose of receiving a medical opinion. I understand my data will be stored for 5 years and handled according to the Privacy Policy.'**
  String get request_consent;

  /// No description provided for @error_request_procedure_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a procedure'**
  String get error_request_procedure_required;

  /// No description provided for @error_note_required.
  ///
  /// In en, this message translates to:
  /// **'Please add an additional note'**
  String get error_note_required;

  /// No description provided for @error_image_required.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one image'**
  String get error_image_required;

  /// No description provided for @opinion_tab_one.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get opinion_tab_one;

  /// No description provided for @opinion_tab_two.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get opinion_tab_two;

  /// No description provided for @opinion_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get opinion_details;

  /// No description provided for @opinion_requested_date.
  ///
  /// In en, this message translates to:
  /// **'Requested On: '**
  String get opinion_requested_date;

  /// No description provided for @opinion_responded_date.
  ///
  /// In en, this message translates to:
  /// **'Responded On: '**
  String get opinion_responded_date;

  /// No description provided for @opinion_years_of_experience.
  ///
  /// In en, this message translates to:
  /// **'+ Years Of Experience'**
  String get opinion_years_of_experience;

  /// No description provided for @opinion_no_requests_found.
  ///
  /// In en, this message translates to:
  /// **'No Requests Found!!'**
  String get opinion_no_requests_found;

  /// No description provided for @opinion_no_consultation_completed.
  ///
  /// In en, this message translates to:
  /// **'No Request completed Yet!!'**
  String get opinion_no_consultation_completed;

  /// No description provided for @opinion_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get opinion_status;

  /// No description provided for @opinion_medical_opinion_for.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion For'**
  String get opinion_medical_opinion_for;

  /// No description provided for @opinion_charges.
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get opinion_charges;

  /// No description provided for @opinion_uploaded_photos.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Photos'**
  String get opinion_uploaded_photos;

  /// No description provided for @opinion_additional_note.
  ///
  /// In en, this message translates to:
  /// **'Additional Note'**
  String get opinion_additional_note;

  /// No description provided for @opinion_doctor_response.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s Response'**
  String get opinion_doctor_response;

  /// No description provided for @opinion_give_feedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get opinion_give_feedback;

  /// No description provided for @opinion_feedback_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Will you plan to visit the doctor for further procedures?'**
  String get opinion_feedback_subtitle;

  /// No description provided for @opinion_send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get opinion_send_feedback;

  /// No description provided for @opinion_your_feedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get opinion_your_feedback;

  /// No description provided for @opinion_your_response.
  ///
  /// In en, this message translates to:
  /// **'Your Response'**
  String get opinion_your_response;

  /// No description provided for @opinion_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get opinion_feedback;

  /// No description provided for @opinion_response.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get opinion_response;

  /// No description provided for @opinion_add_response.
  ///
  /// In en, this message translates to:
  /// **'Add Response'**
  String get opinion_add_response;

  /// No description provided for @opinion_response_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get opinion_response_send;

  /// No description provided for @opinion_response_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Response'**
  String get opinion_response_hint;

  /// No description provided for @opinion_requested_on.
  ///
  /// In en, this message translates to:
  /// **'Requested On: '**
  String get opinion_requested_on;

  /// No description provided for @medical_opinions_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get medical_opinions_chat;

  /// No description provided for @medical_opinion_show_chat.
  ///
  /// In en, this message translates to:
  /// **'Show Chat'**
  String get medical_opinion_show_chat;

  /// Shown when the patient has been waiting for doctor response since creation date
  ///
  /// In en, this message translates to:
  /// **'{userName} has been waiting for the response for the last {days} days'**
  String opinion_waiting_since(String userName, String days);

  /// Heading for the feedback section, includes the patient name
  ///
  /// In en, this message translates to:
  /// **'{userName}\'s feedback'**
  String opinion_feedback_from(String userName);

  /// No description provided for @chat_closed.
  ///
  /// In en, this message translates to:
  /// **'This Chat Has been Closed'**
  String get chat_closed;

  /// No description provided for @write_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your message'**
  String get write_hint;

  /// No description provided for @close_chat.
  ///
  /// In en, this message translates to:
  /// **'Close Chat'**
  String get close_chat;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @failed_to_end_chat.
  ///
  /// In en, this message translates to:
  /// **'Failed to end chat...'**
  String get failed_to_end_chat;

  /// No description provided for @close_subtitle.
  ///
  /// In en, this message translates to:
  /// **'If you close this chat, the conversation will end permanently. You will not be able to send more messages, and the opinion request will be marked as complete.'**
  String get close_subtitle;

  /// No description provided for @report_problem_title.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get report_problem_title;

  /// No description provided for @report_problem_choose_category.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get report_problem_choose_category;

  /// No description provided for @report_problem_write_issue.
  ///
  /// In en, this message translates to:
  /// **'Write Issue'**
  String get report_problem_write_issue;

  /// No description provided for @report_problem_enter_issue.
  ///
  /// In en, this message translates to:
  /// **'Enter Issue'**
  String get report_problem_enter_issue;

  /// No description provided for @report_problem_bug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get report_problem_bug;

  /// No description provided for @report_problem_payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get report_problem_payment;

  /// No description provided for @report_problem_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get report_problem_account;

  /// No description provided for @report_problem_medical_opinion.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion'**
  String get report_problem_medical_opinion;

  /// No description provided for @report_problem_category_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get report_problem_category_required;

  /// No description provided for @report_problem_issue_required.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue.'**
  String get report_problem_issue_required;

  /// No description provided for @report_problem_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get report_problem_submit;

  /// No description provided for @error_loading_reviews.
  ///
  /// In en, this message translates to:
  /// **'Error loading reviews'**
  String get error_loading_reviews;

  /// No description provided for @review_already_received_treatment.
  ///
  /// In en, this message translates to:
  /// **'Have you already received any treatment from this practitioner?'**
  String get review_already_received_treatment;

  /// No description provided for @review_rate_this_doctor.
  ///
  /// In en, this message translates to:
  /// **'Rate this doctor'**
  String get review_rate_this_doctor;

  /// No description provided for @review_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review_review;

  /// No description provided for @review_experience_hint.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get review_experience_hint;

  /// No description provided for @review_no_reviews_available.
  ///
  /// In en, this message translates to:
  /// **'No reviews available.'**
  String get review_no_reviews_available;

  /// No description provided for @review_summary.
  ///
  /// In en, this message translates to:
  /// **'Review Summary'**
  String get review_summary;

  /// No description provided for @reviews_zero.
  ///
  /// In en, this message translates to:
  /// **'0 reviews'**
  String get reviews_zero;

  /// No description provided for @reviews_count.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviews_count(Object count);

  /// No description provided for @review_all.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get review_all;

  /// No description provided for @step3_procedures_pricing.
  ///
  /// In en, this message translates to:
  /// **'Procedures & Pricing'**
  String get step3_procedures_pricing;

  /// No description provided for @step3_add_procedures.
  ///
  /// In en, this message translates to:
  /// **'Add Procedures'**
  String get step3_add_procedures;

  /// No description provided for @step3_selected_procedures.
  ///
  /// In en, this message translates to:
  /// **'Selected procedures'**
  String get step3_selected_procedures;

  /// No description provided for @step3_price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get step3_price_range;

  /// No description provided for @step3_min_price.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get step3_min_price;

  /// No description provided for @step3_max_price.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get step3_max_price;

  /// No description provided for @step3_select_body_part_and_pictures.
  ///
  /// In en, this message translates to:
  /// **'Select Body part And Pictures'**
  String get step3_select_body_part_and_pictures;

  /// No description provided for @step3_before_after_pictures.
  ///
  /// In en, this message translates to:
  /// **'Before/After Pictures'**
  String get step3_before_after_pictures;

  /// No description provided for @step3_no_procedures_selected.
  ///
  /// In en, this message translates to:
  /// **'No procedure selected'**
  String get step3_no_procedures_selected;

  /// No description provided for @step3_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get step3_update;

  /// No description provided for @step3_no_procedure_info.
  ///
  /// In en, this message translates to:
  /// **'Click the “Add” button to upload treated parts along with before & after photos. You can add multiple sets for different procedures or angles.'**
  String get step3_no_procedure_info;

  /// No description provided for @step3_select_body_parts.
  ///
  /// In en, this message translates to:
  /// **'Select Body Parts'**
  String get step3_select_body_parts;

  /// No description provided for @step3_add_pictures.
  ///
  /// In en, this message translates to:
  /// **'Add Pictures'**
  String get step3_add_pictures;

  /// No description provided for @step3_delete_body_part.
  ///
  /// In en, this message translates to:
  /// **'Delete Body Part'**
  String get step3_delete_body_part;

  /// No description provided for @step3_upload_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Upload only images that are necessary for consultation or treatment evaluation.\nIf you choose to upload sensitive images (e.g., private body areas),\nPlease note:\n\t•\tSuch uploads are done at your own risk.\n\t•\tEsthetic Match is not responsible for any misuse, unauthorized sharing, or consequences arising from the upload of sensitive content.\n\t•\tBy uploading, you acknowledge and accept full responsibility for your content.'**
  String get step3_upload_disclaimer;

  /// No description provided for @step3_min_price_error.
  ///
  /// In en, this message translates to:
  /// **'Minimum price cannot be greater than maximum price'**
  String get step3_min_price_error;

  /// No description provided for @step3_price_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Enter valid amount'**
  String get step3_price_validation_error;

  /// No description provided for @step3_negative_price_error.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative'**
  String get step3_negative_price_error;

  /// No description provided for @payment_method_title.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get payment_method_title;

  /// No description provided for @payment_method_enter_stripe_id.
  ///
  /// In en, this message translates to:
  /// **'Enter Stripe ID'**
  String get payment_method_enter_stripe_id;

  /// No description provided for @payment_method_stripe_id.
  ///
  /// In en, this message translates to:
  /// **'Stripe ID*'**
  String get payment_method_stripe_id;

  /// No description provided for @payment_method_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get payment_method_update;

  /// No description provided for @doctor_dashboard_manage_requests.
  ///
  /// In en, this message translates to:
  /// **'Manage your consultation requests'**
  String get doctor_dashboard_manage_requests;

  /// No description provided for @doctor_dashboard_complete_profile.
  ///
  /// In en, this message translates to:
  /// **'Click here to complete profile'**
  String get doctor_dashboard_complete_profile;

  /// No description provided for @doctor_dashboard_profile_stats.
  ///
  /// In en, this message translates to:
  /// **'Profile Stats'**
  String get doctor_dashboard_profile_stats;

  /// No description provided for @doctor_dashboard_profile_matches_likes.
  ///
  /// In en, this message translates to:
  /// **'Profile Matches/Likes'**
  String get doctor_dashboard_profile_matches_likes;

  /// No description provided for @doctor_dashboard_total_consultations.
  ///
  /// In en, this message translates to:
  /// **'Total Consultations'**
  String get doctor_dashboard_total_consultations;

  /// No description provided for @doctor_dashboard_booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get doctor_dashboard_booked;

  /// No description provided for @doctor_dashboard_booking_clicks.
  ///
  /// In en, this message translates to:
  /// **'Booking Clicks'**
  String get doctor_dashboard_booking_clicks;

  /// No description provided for @doctor_dashboard_clicks.
  ///
  /// In en, this message translates to:
  /// **'Clicks'**
  String get doctor_dashboard_clicks;

  /// No description provided for @doctor_dashboard_total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Consultation Earnings'**
  String get doctor_dashboard_total_earnings;

  /// No description provided for @doctor_dashboard_this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get doctor_dashboard_this_week;

  /// No description provided for @doctor_dashboard_this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get doctor_dashboard_this_month;

  /// No description provided for @doctor_dashboard_this_year.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get doctor_dashboard_this_year;

  /// No description provided for @doctor_dashboard_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get doctor_dashboard_week;

  /// No description provided for @doctor_dashboard_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get doctor_dashboard_month;

  /// No description provided for @doctor_dashboard_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get doctor_dashboard_year;

  /// No description provided for @doctor_dashboard_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get doctor_dashboard_no_data;

  /// No description provided for @connectAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect Account'**
  String get connectAccount;

  /// No description provided for @noFundsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No funds available for withdrawal.'**
  String get noFundsAvailable;

  /// No description provided for @connectStripeAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Connect your Stripe account to enable withdrawals and receive payments.'**
  String get connectStripeAccountInfo;

  /// No description provided for @fundsWillBeTransferred.
  ///
  /// In en, this message translates to:
  /// **'Funds will be transferred to your connected Stripe account.'**
  String get fundsWillBeTransferred;

  /// No description provided for @failedRedirectUrl.
  ///
  /// In en, this message translates to:
  /// **'Failed to get redirect URL'**
  String get failedRedirectUrl;

  /// No description provided for @my_wallet_title.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get my_wallet_title;

  /// No description provided for @my_wallet_total_earning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get my_wallet_total_earning;

  /// No description provided for @my_wallet_no_transactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get my_wallet_no_transactions;

  /// No description provided for @my_wallet_withdrawable.
  ///
  /// In en, this message translates to:
  /// **'Withdrawable'**
  String get my_wallet_withdrawable;

  /// Instruction about withdrawal limit and commission fee
  ///
  /// In en, this message translates to:
  /// **'You can withdraw up to {withdrawPercentage}% of your total earnings, The remaining {commissionPercentage}% is retained by Esthetic Match as service charges and platform fees.'**
  String my_wallet_withdraw_instruction(
      int withdrawPercentage, int commissionPercentage);

  /// No description provided for @my_wallet_withdraw_money.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Money'**
  String get my_wallet_withdraw_money;

  /// No description provided for @my_wallet_transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get my_wallet_transaction_history;

  /// No description provided for @my_wallet_see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get my_wallet_see_all;

  /// No description provided for @my_wallet_patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get my_wallet_patients;

  /// No description provided for @my_wallet_failed_to_load_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallet data'**
  String get my_wallet_failed_to_load_data;

  /// Display Error to user
  ///
  /// In en, this message translates to:
  /// **'Error loading wallet data: {error}'**
  String my_wallet_error_loading_data(String error);

  /// No description provided for @active_subscription_active_plan.
  ///
  /// In en, this message translates to:
  /// **'Active Plan'**
  String get active_subscription_active_plan;

  /// No description provided for @active_subscription_no_payment_history.
  ///
  /// In en, this message translates to:
  /// **'No payment history available'**
  String get active_subscription_no_payment_history;

  /// No description provided for @active_subscription_total_clicks.
  ///
  /// In en, this message translates to:
  /// **'Total Clicks Used'**
  String get active_subscription_total_clicks;

  /// No description provided for @active_subscription_payment_history.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get active_subscription_payment_history;

  /// No description provided for @active_subscription_change_plan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get active_subscription_change_plan;

  /// No description provided for @active_subscription_cancel_plan.
  ///
  /// In en, this message translates to:
  /// **'Cancel Plan'**
  String get active_subscription_cancel_plan;

  /// No description provided for @active_subscription_clicks.
  ///
  /// In en, this message translates to:
  /// **'Clicks'**
  String get active_subscription_clicks;

  /// No description provided for @active_subscription_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get active_subscription_price;

  /// No description provided for @active_subscription_billing_month.
  ///
  /// In en, this message translates to:
  /// **'Billing Month'**
  String get active_subscription_billing_month;

  /// No description provided for @active_subscription_current_plan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get active_subscription_current_plan;

  /// No description provided for @active_subscription_pay_as_you_go.
  ///
  /// In en, this message translates to:
  /// **'Pay as you go'**
  String get active_subscription_pay_as_you_go;

  /// No description provided for @active_subscription_monthly_50_plan.
  ///
  /// In en, this message translates to:
  /// **'Monthly 50 Plan'**
  String get active_subscription_monthly_50_plan;

  /// No description provided for @active_subscription_free_plan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get active_subscription_free_plan;

  /// No description provided for @active_subscription_clicks_remaining.
  ///
  /// In en, this message translates to:
  /// **'Clicks Remaining'**
  String get active_subscription_clicks_remaining;

  /// No description provided for @active_subscription_next_billing_date.
  ///
  /// In en, this message translates to:
  /// **'Next Billing Date'**
  String get active_subscription_next_billing_date;

  /// No description provided for @active_subscription_almost_out_of_clicks.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost out of clicks!\nRenew your subscription or buy extra clicks with \"Pay as you go\".'**
  String get active_subscription_almost_out_of_clicks;

  /// No description provided for @active_subscription_clicks_reach_zero_message.
  ///
  /// In en, this message translates to:
  /// **'When your clicks reach 0, your profile will be hidden.\nPlease buy more clicks or change your plan to stay visible.'**
  String get active_subscription_clicks_reach_zero_message;

  /// No description provided for @active_subscription_change_plan_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Change Plan\" button to continue.'**
  String get active_subscription_change_plan_hint;

  /// No description provided for @active_subscription_on_payment_success.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful!'**
  String get active_subscription_on_payment_success;

  /// No description provided for @active_subscription_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get active_subscription_status;

  /// No description provided for @active_subscription_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get active_subscription_cancelled;

  /// No description provided for @active_subscription_plan_end_date_info.
  ///
  /// In en, this message translates to:
  /// **'Your current plan will remain active until'**
  String get active_subscription_plan_end_date_info;

  /// No description provided for @active_subscription_cancelled_message.
  ///
  /// In en, this message translates to:
  /// **'Your Subscription Has Been Cancelled'**
  String get active_subscription_cancelled_message;

  /// No description provided for @active_subscription_cancelled_success_message.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled successfully'**
  String get active_subscription_cancelled_success_message;

  /// No description provided for @active_subscription_ios_cancel_instruction.
  ///
  /// In en, this message translates to:
  /// **'To Cancel your subscription, please go to Settings → Subscriptions.'**
  String get active_subscription_ios_cancel_instruction;

  /// No description provided for @procedure_selection_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get procedure_selection_search_hint;

  /// No description provided for @procedure_selection_title.
  ///
  /// In en, this message translates to:
  /// **'Select procedures'**
  String get procedure_selection_title;

  /// Label shown next to title when a maximum selection limit applies
  ///
  /// In en, this message translates to:
  /// **' (Max {max})'**
  String procedure_selection_max_label(int max);

  /// No description provided for @procedure_selection_tab_surgical.
  ///
  /// In en, this message translates to:
  /// **'Surgical'**
  String get procedure_selection_tab_surgical;

  /// No description provided for @procedure_selection_tab_non_surgical.
  ///
  /// In en, this message translates to:
  /// **'Non-Surgical'**
  String get procedure_selection_tab_non_surgical;

  /// No description provided for @procedure_selection_no_procedures.
  ///
  /// In en, this message translates to:
  /// **'No procedures found'**
  String get procedure_selection_no_procedures;

  /// No description provided for @procedure_selection_unknown_procedure.
  ///
  /// In en, this message translates to:
  /// **'Unknown Procedure'**
  String get procedure_selection_unknown_procedure;

  /// No description provided for @procedure_selection_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get procedure_selection_done;

  /// Label for done button with selected count
  ///
  /// In en, this message translates to:
  /// **'Done ({count} selected)'**
  String procedure_selection_done_with_count(int count);

  /// Label shown next to title when a maximum selection limit applies.
  ///
  /// In en, this message translates to:
  /// **' (Max {max})'**
  String multi_selection_max_label(int max);

  /// Error message when user selects more than the allowed maximum.
  ///
  /// In en, this message translates to:
  /// **'You can only select {max} items'**
  String multi_selection_max_limit(int max);

  /// No description provided for @multi_selection_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get multi_selection_done;

  /// Button label showing how many items are selected.
  ///
  /// In en, this message translates to:
  /// **'Done ({count} selected)'**
  String multi_selection_done_with_count(int count);

  /// No description provided for @activity_title_liked_profiles.
  ///
  /// In en, this message translates to:
  /// **'Your Liked Profiles'**
  String get activity_title_liked_profiles;

  /// No description provided for @activity_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search liked doctors...'**
  String get activity_search_hint;

  /// No description provided for @activity_no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get activity_no_results_found;

  /// No description provided for @activity_results_found.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No liked doctors found} =1 {1 liked doctor found} other {{count} liked doctors found}}'**
  String activity_results_found(num count);

  /// No description provided for @activity_no_practitioner_matches_searching.
  ///
  /// In en, this message translates to:
  /// **'Oops, No Practitioner Matches\nFound!!'**
  String get activity_no_practitioner_matches_searching;

  /// No description provided for @activity_no_practitioner_matches.
  ///
  /// In en, this message translates to:
  /// **'Oops, No Matched\nPractitioner'**
  String get activity_no_practitioner_matches;

  /// No description provided for @before_after_no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get before_after_no_data_available;

  /// No description provided for @doctor_profile_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get doctor_profile_about;

  /// No description provided for @doctor_profile_medical_specialty.
  ///
  /// In en, this message translates to:
  /// **'Medical Specialty'**
  String get doctor_profile_medical_specialty;

  /// No description provided for @doctor_profile_my_top_03.
  ///
  /// In en, this message translates to:
  /// **'My Top 03'**
  String get doctor_profile_my_top_03;

  /// No description provided for @doctor_profile_procedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get doctor_profile_procedures;

  /// No description provided for @doctor_profile_view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get doctor_profile_view_all;

  /// No description provided for @doctor_profile_request_opinion.
  ///
  /// In en, this message translates to:
  /// **'Request Opinion'**
  String get doctor_profile_request_opinion;

  /// No description provided for @doctor_profile_no_procedures_for_opinion.
  ///
  /// In en, this message translates to:
  /// **'This doctor is currently not offering any medical procedure.'**
  String get doctor_profile_no_procedures_for_opinion;

  /// No description provided for @doctor_profile_book_appointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get doctor_profile_book_appointment;

  /// No description provided for @doctor_profile_invalid_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Invalid booking link'**
  String get doctor_profile_invalid_booking_link;

  /// No description provided for @doctor_profile_could_not_open_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Could not open booking link'**
  String get doctor_profile_could_not_open_booking_link;

  /// No description provided for @doctor_profile_no_remaining_booking_clicks.
  ///
  /// In en, this message translates to:
  /// **'No remaining booking clicks available'**
  String get doctor_profile_no_remaining_booking_clicks;

  /// No description provided for @doctor_profile_failed_register_booking_click.
  ///
  /// In en, this message translates to:
  /// **'Failed to register booking click'**
  String get doctor_profile_failed_register_booking_click;

  /// No description provided for @doctor_profile_could_not_launch_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Could not launch booking link'**
  String get doctor_profile_could_not_launch_booking_link;

  /// No description provided for @doctor_profile_error_opening_booking_link.
  ///
  /// In en, this message translates to:
  /// **'Error opening booking link'**
  String get doctor_profile_error_opening_booking_link;

  /// No description provided for @doctor_profile_newbie.
  ///
  /// In en, this message translates to:
  /// **'Newbie'**
  String get doctor_profile_newbie;

  /// No description provided for @doctor_profile_years_experience.
  ///
  /// In en, this message translates to:
  /// **'{years}+ Years Of Experience'**
  String doctor_profile_years_experience(Object years);

  /// No description provided for @doctor_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Dr. {firstName} {lastName}'**
  String doctor_profile_name(Object firstName, Object lastName);

  /// No description provided for @doctor_profile_rating.
  ///
  /// In en, this message translates to:
  /// **'{rating}/5'**
  String doctor_profile_rating(Object rating);

  /// No description provided for @doctor_profile_distance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String doctor_profile_distance(Object distance);

  /// No description provided for @subscription_clicks.
  ///
  /// In en, this message translates to:
  /// **'Clicks'**
  String get subscription_clicks;

  /// No description provided for @subscription_plan_price.
  ///
  /// In en, this message translates to:
  /// **'Plan Price'**
  String get subscription_plan_price;

  /// No description provided for @subscription_autorenewing.
  ///
  /// In en, this message translates to:
  /// **'(Auto-renewing)'**
  String get subscription_autorenewing;

  /// No description provided for @subscription_terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get subscription_terms_of_service;

  /// No description provided for @subscription_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscription_monthly;

  /// No description provided for @subscription_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscription_free;

  /// No description provided for @subscription_5_per_month.
  ///
  /// In en, this message translates to:
  /// **'5/Month'**
  String get subscription_5_per_month;

  /// No description provided for @subscription_50_per_month.
  ///
  /// In en, this message translates to:
  /// **'50/Month'**
  String get subscription_50_per_month;

  /// No description provided for @subscription_650_chf.
  ///
  /// In en, this message translates to:
  /// **'650 CHF'**
  String get subscription_650_chf;

  /// No description provided for @subscription_payg_10.
  ///
  /// In en, this message translates to:
  /// **'10'**
  String get subscription_payg_10;

  /// No description provided for @subscription_payg_270_chf.
  ///
  /// In en, this message translates to:
  /// **'270 CHF'**
  String get subscription_payg_270_chf;

  /// No description provided for @subscription_payg_15.
  ///
  /// In en, this message translates to:
  /// **'15'**
  String get subscription_payg_15;

  /// No description provided for @subscription_payg_480_chf.
  ///
  /// In en, this message translates to:
  /// **'480 CHF'**
  String get subscription_payg_480_chf;

  /// No description provided for @subscription_payg_20.
  ///
  /// In en, this message translates to:
  /// **'20'**
  String get subscription_payg_20;

  /// No description provided for @subscription_payg_700_chf.
  ///
  /// In en, this message translates to:
  /// **'700 CHF'**
  String get subscription_payg_700_chf;

  /// No description provided for @subscription_payg_30.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get subscription_payg_30;

  /// No description provided for @subscription_payg_1100_chf.
  ///
  /// In en, this message translates to:
  /// **'1100 CHF'**
  String get subscription_payg_1100_chf;

  /// No description provided for @subscription_monthly_50_plan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get subscription_monthly_50_plan;

  /// No description provided for @subscription_monthly_50_plan_description.
  ///
  /// In en, this message translates to:
  /// **'Unlimited clicks every month / year, profile always visible'**
  String get subscription_monthly_50_plan_description;

  /// No description provided for @subscription_unlimited_clicks.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Clicks'**
  String get subscription_unlimited_clicks;

  /// No description provided for @subscription_pay_as_you_go.
  ///
  /// In en, this message translates to:
  /// **'Pay as you go'**
  String get subscription_pay_as_you_go;

  /// No description provided for @subscription_pay_as_you_go_description.
  ///
  /// In en, this message translates to:
  /// **'Flexible, pay only for the clicks you use'**
  String get subscription_pay_as_you_go_description;

  /// No description provided for @subscription_choose_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get subscription_choose_plan;

  /// No description provided for @subscription_choose_visibility_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Visibility Plan'**
  String get subscription_choose_visibility_plan;

  /// No description provided for @subscription_stay_visible_message.
  ///
  /// In en, this message translates to:
  /// **'Stay visible to patients with the plan that suits you best'**
  String get subscription_stay_visible_message;

  /// No description provided for @subscription_pricing_table.
  ///
  /// In en, this message translates to:
  /// **'Pricing Table:'**
  String get subscription_pricing_table;

  /// No description provided for @subscription_how_it_works.
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get subscription_how_it_works;

  /// No description provided for @subscription_pay_as_you_go_instruction_1.
  ///
  /// In en, this message translates to:
  /// **'1 click = redirect to your booking link'**
  String get subscription_pay_as_you_go_instruction_1;

  /// No description provided for @subscription_pay_as_you_go_instruction_2.
  ///
  /// In en, this message translates to:
  /// **'5 click lefts → alert'**
  String get subscription_pay_as_you_go_instruction_2;

  /// No description provided for @subscription_pay_as_you_go_instruction_3.
  ///
  /// In en, this message translates to:
  /// **'0 clicks → profile hidden until recharge'**
  String get subscription_pay_as_you_go_instruction_3;

  /// No description provided for @subscription_whats_included.
  ///
  /// In en, this message translates to:
  /// **'What\'s included:'**
  String get subscription_whats_included;

  /// No description provided for @subscription_yearly_plan_instruction_1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited tracked clicks'**
  String get subscription_yearly_plan_instruction_1;

  /// No description provided for @subscription_yearly_plan_instruction_2.
  ///
  /// In en, this message translates to:
  /// **'Profile always visible'**
  String get subscription_yearly_plan_instruction_2;

  /// No description provided for @subscription_yearly_plan_instruction_3.
  ///
  /// In en, this message translates to:
  /// **'Monthly or yearly billing'**
  String get subscription_yearly_plan_instruction_3;

  /// No description provided for @subscription_yearly_plan_instruction_4.
  ///
  /// In en, this message translates to:
  /// **'Buy extra clicks anytime (Pay-as-you-go)'**
  String get subscription_yearly_plan_instruction_4;

  /// No description provided for @subscription_failed_to_init_purchases.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize purchases'**
  String get subscription_failed_to_init_purchases;

  /// No description provided for @subscription_purchase_success.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful!'**
  String get subscription_purchase_success;

  /// No description provided for @subscription_purchase_failed_try_again.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get subscription_purchase_failed_try_again;

  /// No description provided for @subscription_init_purchases.
  ///
  /// In en, this message translates to:
  /// **'Initializing purchases...'**
  String get subscription_init_purchases;

  /// No description provided for @subscription_for_annual_plan.
  ///
  /// In en, this message translates to:
  /// **'For Annual Plan'**
  String get subscription_for_annual_plan;

  /// No description provided for @subscription_for_annual_monthly_plan.
  ///
  /// In en, this message translates to:
  /// **'For Annual/Monthly Plan'**
  String get subscription_for_annual_monthly_plan;

  /// No description provided for @subscription_already_subscribed_message.
  ///
  /// In en, this message translates to:
  /// **'You have already subscribed to this plan'**
  String get subscription_already_subscribed_message;

  /// No description provided for @subscription_contact_email.
  ///
  /// In en, this message translates to:
  /// **'contact estheticmatch@gmail.com'**
  String get subscription_contact_email;

  /// No description provided for @subscription_get_full_year_premium.
  ///
  /// In en, this message translates to:
  /// **'Get a full year of premium features with one easy payment.'**
  String get subscription_get_full_year_premium;

  /// No description provided for @subscription_get_full_year_month_premium.
  ///
  /// In en, this message translates to:
  /// **'Get premium features for the whole month/year with one easy payment !'**
  String get subscription_get_full_year_month_premium;

  /// No description provided for @exception_check_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'We\'re unable to show results.\nPlease check your data\nconnection.'**
  String get exception_check_internet_connection;

  /// No description provided for @exception_retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get exception_retry;

  /// No description provided for @unknown_page_not_found.
  ///
  /// In en, this message translates to:
  /// **'\'Page Not Found\''**
  String get unknown_page_not_found;

  /// No description provided for @unknown_page_does_not_exist.
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t seem to exist.'**
  String get unknown_page_does_not_exist;

  /// No description provided for @unknown_oops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get unknown_oops;

  /// No description provided for @wallet_no_wallet_data.
  ///
  /// In en, this message translates to:
  /// **'No wallet data available'**
  String get wallet_no_wallet_data;

  /// No description provided for @opinion_error_loading_details.
  ///
  /// In en, this message translates to:
  /// **'Error loading details'**
  String get opinion_error_loading_details;

  /// No description provided for @doctor_signature_brand_tech.
  ///
  /// In en, this message translates to:
  /// **'Signature Techniques, Brands and Technologies'**
  String get doctor_signature_brand_tech;

  /// No description provided for @profile_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Profile Incomplete'**
  String get profile_incomplete;

  /// No description provided for @profile_fill_requirements.
  ///
  /// In en, this message translates to:
  /// **'Please fill up the following requirements to proceed:'**
  String get profile_fill_requirements;

  /// No description provided for @profile_procedure_types_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Procedure types not selected.'**
  String get profile_procedure_types_not_selected;

  /// No description provided for @profile_price_range_missing.
  ///
  /// In en, this message translates to:
  /// **'Price range missing.'**
  String get profile_price_range_missing;

  /// No description provided for @profile_before_after_images_not_added.
  ///
  /// In en, this message translates to:
  /// **'Before/After images not added.'**
  String get profile_before_after_images_not_added;

  /// No description provided for @profile_body_parts_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Body parts not specified.'**
  String get profile_body_parts_not_specified;

  /// No description provided for @profile_waiting_for_approval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get profile_waiting_for_approval;

  /// No description provided for @profile_verified.
  ///
  /// In en, this message translates to:
  /// **'Profile verified'**
  String get profile_verified;

  /// No description provided for @profile_rejected.
  ///
  /// In en, this message translates to:
  /// **'Profile rejected'**
  String get profile_rejected;

  /// No description provided for @profile_preview_profile.
  ///
  /// In en, this message translates to:
  /// **'Preview Profile'**
  String get profile_preview_profile;

  /// No description provided for @profile_hidden_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile Hidden'**
  String get profile_hidden_profile;

  /// No description provided for @profile_hidden_profile_dialog.
  ///
  /// In en, this message translates to:
  /// **'\"0\" Clicks left. Your profile is hidden from patients. Please buy more clicks or change your plan to stay visible.'**
  String get profile_hidden_profile_dialog;

  /// No description provided for @before_after_gallery.
  ///
  /// In en, this message translates to:
  /// **'Before/After Gallery'**
  String get before_after_gallery;

  /// No description provided for @before_after_desclaimer_title.
  ///
  /// In en, this message translates to:
  /// **'Patient Image & Data Disclaimer'**
  String get before_after_desclaimer_title;

  /// No description provided for @before_after_desclaimer_1.
  ///
  /// In en, this message translates to:
  /// **'The before-and-after photos displayed in this gallery are shared with the explicit, written consent of each patient for educational and illustrative purposes.'**
  String get before_after_desclaimer_1;

  /// No description provided for @before_after_desclaimer_2.
  ///
  /// In en, this message translates to:
  /// **'All images are processed and stored in compliance with GDPR (EU Regulation 2016/679) and LPD (Switzerland).'**
  String get before_after_desclaimer_2;

  /// No description provided for @before_after_desclaimer_3.
  ///
  /// In en, this message translates to:
  /// **'Personal identifiers have been removed where possible.'**
  String get before_after_desclaimer_3;

  /// No description provided for @before_after_desclaimer_4.
  ///
  /// In en, this message translates to:
  /// **'The results shown reflect individual cases and do not guarantee similar outcomes.'**
  String get before_after_desclaimer_4;

  /// No description provided for @before_after_desclaimer_5.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized reproduction, download, or sharing of these images is strictly prohibited.'**
  String get before_after_desclaimer_5;

  /// No description provided for @user_home_instruction_1.
  ///
  /// In en, this message translates to:
  /// **'Swipe Cards to see more doctors.'**
  String get user_home_instruction_1;

  /// No description provided for @user_home_instruction_2.
  ///
  /// In en, this message translates to:
  /// **'Liked doctors will be shown in the \"Activity Page\".'**
  String get user_home_instruction_2;

  /// No description provided for @user_home_instruction_3.
  ///
  /// In en, this message translates to:
  /// **'Swipe skips the doctor.'**
  String get user_home_instruction_3;

  /// No description provided for @user_home_instruction_4.
  ///
  /// In en, this message translates to:
  /// **'Disliked button skips the doctor and hide from profile matches.'**
  String get user_home_instruction_4;

  /// No description provided for @search_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get search_clear;

  /// Displays the doctor's full name with the 'Dr.' prefix.
  ///
  /// In en, this message translates to:
  /// **'Dr. {firstName} {lastName}'**
  String doctorFullName(String firstName, String lastName);

  /// No description provided for @info_complete_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get info_complete_profile;

  /// No description provided for @exception_location_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Location not specified'**
  String get exception_location_not_specified;

  /// No description provided for @exception_clinic_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Clinic not specified'**
  String get exception_clinic_not_specified;

  /// No description provided for @exception_general_practice.
  ///
  /// In en, this message translates to:
  /// **'General Practice'**
  String get exception_general_practice;

  /// No description provided for @add_image.
  ///
  /// In en, this message translates to:
  /// **'\'Add Image'**
  String get add_image;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
