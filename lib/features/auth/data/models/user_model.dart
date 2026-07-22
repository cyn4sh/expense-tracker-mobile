class UserModel {
  final int? id;
  final String username;
  final String email;
  final bool notificationsEnabled;
  final bool emailVerified;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    this.notificationsEnabled = true,
    this.emailVerified = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailVerified: json['email_verified'] as bool? ?? true,
    );
  }
}