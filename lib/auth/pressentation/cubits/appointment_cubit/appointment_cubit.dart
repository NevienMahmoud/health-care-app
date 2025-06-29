import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care_app/auth/data/models/appointment_model.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  Future<void> getAppointmentsForDoctor() async {
    emit(AppointmentLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('logged_in_email');

      if (email == null || email.isEmpty) {
        emit(AppointmentError("Email not found"));
        return;
      }

      /// Get all doctors
      final doctorResponse = await Dio().get('https://healthcare-4scv.vercel.app/api/doctors/doctors');
      final List doctors = doctorResponse.data['data'];

      /// Find the doctor by email
      final doctor = doctors.firstWhere(
            (doc) => doc['email'] == email,
        orElse: () => null,
      );

      if (doctor == null) {
        emit(AppointmentError("Doctor not found"));
        return;
      }

      final doctorId = doctor['_id'];

      /// Get doctor appointments
      final response = await Dio().get(
        'https://healthcare-4scv.vercel.app/api/appointments/doctor/$doctorId',
      );

      final List data = response.data['data'];

      final appointments = data
          .map((json) => AppointmentModel.fromJson(json))
          .toList();

      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError("Failed to load appointments"));
    }
  }
}