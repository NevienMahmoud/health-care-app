part of 'doctor_cubit.dart';

@immutable
abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final DoctorModel doctor;

  DoctorLoaded(this.doctor);
}