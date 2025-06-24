// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:health_care_app/auth/data/models/doctor_profile_model.dart';
//
// class DoctorService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://healthcare-4scv.vercel.app/api',
//     ),
//   );
//
//   Future<DoctorProfileModel> getDoctorById(String id) async {
//     try {
//       Response response = await _dio.get('/doctors/doctors/$id');
//
//       if (response.statusCode == 200) {
//         final data = response.data['data'];
//         return DoctorProfileModel.fromJson(data);
//       } else {
//         throw Exception('Failed to fetch doctor data');
//       }
//     } on DioException catch (e) {
//       final errorMessage =
//           e.response?.data['message'] ?? 'Oops, something went wrong';
//       throw Exception(errorMessage);
//     } catch (e) {
//       log('Get doctor error: $e');
//       throw Exception('Oops, something went wrong');
//     }
//   }
// }
