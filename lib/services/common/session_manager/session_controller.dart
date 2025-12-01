// import 'package:esthetic_match/app/utils/enums.dart';
// import 'package:esthetic_match/app/utils/local_storage.dart';
// import 'package:esthetic_match/model/doctor/doctor_model.dart';
// import 'package:esthetic_match/model/general/procedure_catalog.dart';
// import 'package:esthetic_match/model/user/user_model.dart';

// Enum for storage keys to prevent typos
import 'package:vendr/app/utils/local_storage.dart';
import 'dart:developer';

enum StorageKey {
  accessToken('access_token'),
  refreshToken('refresh_token'),
  userType('user_type'),
  procedures('procedures'),
  medicalSpecialty('medical_specialty'),
  user('user'),
  doctor('doctor');

  const StorageKey(this.value);
  final String value;
}

class SessionController {
  //   factory SessionController() => _instance;
  //   SessionController._internal();
  //   static final SessionController _instance = SessionController._internal();
  final LocalStorage _localStorage = LocalStorage();

  String? _token;
  String? _refreshToken;
  //   UserModel? _user;
  //   DoctorModel? _doctor;
  //   UserType? userType;
  //   List<ProcedureCatalogModel>? _procedures;
  //   List<MedicalSpecialtyModel>? _medicalSpecialty;
  //   bool? _isPlanCancelled;

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  //   UserModel? get user => _user;
  //   DoctorModel? get doctor => _doctor;
  //   List<ProcedureCatalogModel>? get procedures => _procedures;
  //   List<MedicalSpecialtyModel>? get medicalSpecialty => _medicalSpecialty;
  bool get isLoggedIn => _token != null;
  //   bool get isPlanCancelled => _isPlanCancelled ?? false;

  //   bool _initialized = false;
  //   Future<void>? _initFuture;

  Future<void> init() {
    // if (_initialized) return Future.value();
    // _initFuture ??= _initializeSession();
    // return _initFuture!;
    return Future.value();
  }

  //   Future<void> _initializeSession() async {
  //     _token = await _localStorage.readValue(StorageKey.authToken.value);
  //     final type = await _localStorage.readValue(StorageKey.userType.value);

  //     // Load user data
  //     final userString = await _localStorage.readValue(StorageKey.user.value);
  //     if (userString != null) {
  //       try {
  //         final userJson = jsonDecode(userString) as Map<String, dynamic>;
  //         _user = UserModel.fromJson(userJson);
  //       } catch (e) {
  //         log('Failed to decode user: $e');
  //         _user = null;
  //       }
  //     }

  //     // Load doctor data
  //     final doctorString = await _localStorage.readValue(StorageKey.doctor.value);
  //     if (doctorString != null) {
  //       try {
  //         final doctorJson = jsonDecode(doctorString) as Map<String, dynamic>;
  //         _doctor = DoctorModel.fromJson(doctorJson);
  //       } catch (e) {
  //         log('Failed to decode doctor: $e');
  //         _doctor = null;
  //       }
  //     }

  //     // Load procedures
  //     final proceduresString =
  //         await _localStorage.readValue(StorageKey.procedures.value);
  //     if (proceduresString != null) {
  //       try {
  //         final decoded = jsonDecode(proceduresString) as List<dynamic>;
  //         _procedures = decoded
  //             .map((e) =>
  //                 ProcedureCatalogModel.fromJson(e as Map<String, dynamic>))
  //             .toList();
  //       } catch (e) {
  //         log('Failed to decode procedures: $e');
  //         _procedures = null;
  //       }
  //     }

  //     // Load medical specialties
  //     final specialtiesString =
  //         await _localStorage.readValue(StorageKey.medicalSpecialty.value);
  //     if (specialtiesString != null) {
  //       try {
  //         final decoded = jsonDecode(specialtiesString) as List<dynamic>;
  //         _medicalSpecialty = decoded
  //             .map((e) =>
  //                 MedicalSpecialtyModel.fromJson(e as Map<String, dynamic>))
  //             .toList();
  //       } catch (e) {
  //         log('Failed to decode medical specialties: $e');
  //         _medicalSpecialty = null;
  //       }
  //     }

  //     if (type != null) {
  //       userType = UserType.fromString(type);
  //       log('User type loaded: $type');
  //     }
  //     if (_token != null) {
  //       log('Token loaded: $_token');
  //     }
  //     _initialized = true;
  //   }

  //   Future<void> saveUserType() async {
  //     if (userType == null) {
  //       log('User type is null, cannot save to local storage');
  //       return;
  //     }
  //     await _localStorage.setValue(StorageKey.userType.value, userType!.value);
  //     log('User type saved: ${userType!.value}');
  //   }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    _token = accessToken;
    _refreshToken = refreshToken;
    await _localStorage.setValue(StorageKey.accessToken.value, accessToken);
    log('Access Token saved: $token');
    await _localStorage.setValue(StorageKey.refreshToken.value, refreshToken);
    log('Refresh Token saved: $refreshToken');
  }

  //   Future<void> saveUser(UserModel user) async {
  //     _user = user;
  //     final encoded = jsonEncode(user.toJson());
  //     await _localStorage.setValue(StorageKey.user.value, encoded);
  //     log('User saved: ${user.id}');
  //   }

  //   Future<void> saveDoctor(DoctorModel doctor) async {
  //     _doctor = doctor;
  //     final encoded = jsonEncode(doctor.toJson());
  //     await _localStorage.setValue(StorageKey.doctor.value, encoded);
  //     log('Doctor saved: ${doctor.id}');
  //   }

  //   Future<void> saveProcedures(List<ProcedureCatalogModel> procedures) async {
  //     _procedures = procedures;
  //     final encoded = jsonEncode(procedures.map((e) => e.toJson()).toList());
  //     await _localStorage.setValue(StorageKey.procedures.value, encoded);
  //     log('Procedures saved');
  //   }

  //   Future<void> saveMedicalSpecialty(
  //       List<MedicalSpecialtyModel> medicalSpecialty) async {
  //     _medicalSpecialty = medicalSpecialty;
  //     final encoded =
  //         jsonEncode(medicalSpecialty.map((e) => e.toJson()).toList());
  //     await _localStorage.setValue(StorageKey.medicalSpecialty.value, encoded);
  //     log('Medical specialties saved');
  //   }

  //   // ignore: use_setters_to_change_properties
  //   void updatePlanCancelledStatus({bool isCancelled = false}) {
  //     _isPlanCancelled = isCancelled;
  //   }

  Future<void> clearSession() async {
    _token = null;
    _refreshToken = null;
    // _user = null;
    // _doctor = null;
    // userType = null;
    // _procedures = null;
    // _medicalSpecialty = null;

    // Clear all storage values using the enum
    await _localStorage.clearValue(StorageKey.accessToken.value);
    await _localStorage.clearValue(StorageKey.refreshToken.value);
    // await _localStorage.clearValue(StorageKey.userType.value);
    // await _localStorage.clearValue(StorageKey.user.value);
    // await _localStorage.clearValue(StorageKey.doctor.value);
    // await _localStorage.clearValue(StorageKey.procedures.value);
    // await _localStorage.clearValue(StorageKey.medicalSpecialty.value);

    log('Session cleared: All data removed');
  }
}
