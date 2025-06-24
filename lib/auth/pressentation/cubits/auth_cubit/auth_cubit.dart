import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:health_care_app/auth/data/services/auth_service.dart';
import 'package:health_care_app/auth/data/models/doctor_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password, String userType) async {
    emit(AuthLoading());
    try {
      final response = await _authService.login(email, password, userType);
      final user = response['user'];

      log('👤 User from response: $user');

      final extractedUserType = user['userType'];
      final userId = user['_id'] ?? user['id'];

      log('📌 User type: $extractedUserType');
      log('🆔 User ID: $userId');

      DoctorProfileModel? doctorProfile;

      // ✅ لو المستخدم دكتور، استدعي بياناته الكاملة
      if (extractedUserType == 'doctor' && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('doctorId', userId);

        final doctorResponse = await Dio().get(
          'http://healthcare-4scv.vercel.app/api/doctors/doctors/$userId',
        );

        doctorProfile = DoctorProfileModel.fromJson(doctorResponse.data['doctor']);
      }

      emit(AuthSuccess(
        userType: extractedUserType,
        doctor: doctorProfile,
      ));
    } catch (e) {
      log('❌ Login error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup({
    String? specialization,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
    required String phoneNumber,
    required String address,
    required String userType,
  }) async {
    emit(AuthLoading());
    try {
      await _authService.signup(
        specialization: specialization,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        address: address,
        userType: userType,
      );
      emit(AuthSuccess(userType: userType)); // ✅ بدون doctor
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}