class DoctorProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;
  final double averageRating;

  DoctorProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.averageRating,
  });

  String get fullName => '$firstName $lastName';

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
        id: json['_id'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        specialization: json['specialization'] ?? '',
        averageRating: double.tryParse(json['averageRating']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}