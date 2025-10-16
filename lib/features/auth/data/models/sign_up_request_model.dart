class SignUpRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String dateOfBirth;
  final String phone;

  SignUpRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
    };
  }
}
