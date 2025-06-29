import 'package:flutter/material.dart';
import 'package:health_care_app/auth/data/models/appointment_model.dart';

import  'appointment_cubit.dart';

@immutable
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;

  AppointmentLoaded(this.appointments);
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}