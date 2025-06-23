import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:health_care_app/auth/data/models/doctor_model.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());

  DoctorModel? _doctor;

  DoctorModel? get doctor => _doctor;

  void setDoctor(DoctorModel doctor) {
    _doctor = doctor;
    emit(DoctorLoaded(doctor));
  }

  void clearDoctor() {
    _doctor = null;
    emit(DoctorInitial());
    }
}