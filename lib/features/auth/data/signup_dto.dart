// signup_dto.dart
class SignupDto {
  final String username;
  final String email;
  final String password;
  final String password2;

  const SignupDto({
    required this.username,
    required this.email,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'password2': password2,
  };
}