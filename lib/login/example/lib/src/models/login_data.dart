import 'package:quiver/core.dart';

class LoginData {
  final String email;
  final String password;
  final String name;
  final String phone;

  LoginData({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  @override
  String toString() {
    return '$runtimeType($email, $password,$phone)';
  }

  @override
  bool operator ==(Object other) {
    if (other is LoginData) {
      return email == other.email &&
          password == other.password &&
          name == other.name &&
          phone == other.phone;
    }
    return false;
  }

  @override
  int get hashCode => hash4(email, password, name, phone);
}
