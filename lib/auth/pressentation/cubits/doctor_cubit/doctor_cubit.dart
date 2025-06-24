import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:health_care_app/auth/data/models/doctor_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial()) {
    getDoctorProfile();
  }

  DoctorProfileModel? doctor;

  Future<void> getDoctorProfile() async {
    emit(DoctorLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString('doctorId');

      log('Retrieved doctorId: $doctorId');

      if (doctorId == null || doctorId.isEmpty) {
        emit(DoctorError('Doctor ID not found'));
        return;
      }

      final response = await Dio().get(
        'http://healthcare-4scv.vercel.app/api/doctors/doctors/$doctorId',
      );

      doctor = DoctorProfileModel.fromJson(response.data['doctor']);
      emit(DoctorSuccess());
    } catch (e) {
      log("DoctorCubit error: $e");
      emit(DoctorError("Failed to fetch doctor data"));
    }
  }
}