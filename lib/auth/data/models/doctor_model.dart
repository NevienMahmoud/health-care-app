class DoctorModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final String phoneNumber;
  final String address;
  final String? specialization;
  final String? image;
  final double? wallet;
  final double? rate;
  final String? password;
  final String? confirmPassword;

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.phoneNumber,
    required this.address,
    this.specialization,
    this.image,
    this.wallet,
    this.rate,
    this.password,
    this.confirmPassword,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      specialization: json['specialization'],
      image: json['image'],
      wallet: (json['wallet'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }

  String get fullName => '$firstName $lastName';
}