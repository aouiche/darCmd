import 'package:flutter/material.dart';

import '../../flutter_login.dart';
import '../models/login_data.dart';

enum AuthMode { Signup, Login }

/// The result is an error message, callback successes if message is null
typedef AuthCallback = Future<String?>? Function(LoginData);

/// The result is an error message, callback successes if message is null
typedef ProviderAuthCallback = Future<String?>? Function();

/// The result is an error message, callback successes if message is null
typedef RecoverCallback = Future<String?>? Function(String);

class Auth with ChangeNotifier {
  Auth({
    this.loginProviders = const [],
    this.onLogin,
    this.onSignup,
    this.onRecoverPassword,
    String email = '',
    String password = '',
    String confirmPassword = '',
    String name = '',
    String phone = '',
    String zomra = '',
    String wilaya = '',
    String address = '',
  })  : _email = email,
        _password = password,
        _confirmPassword = confirmPassword,
        _name = name,
        _phone = phone,
        _zomra = zomra,
        _wilaya = wilaya,
        _address = address;

  final AuthCallback? onLogin;
  final AuthCallback? onSignup;
  final RecoverCallback? onRecoverPassword;
  final List<LoginProvider> loginProviders;

  AuthMode _mode = AuthMode.Login;

  AuthMode get mode => _mode;
  set mode(AuthMode value) {
    _mode = value;
    notifyListeners();
  }

  bool get isLogin => _mode == AuthMode.Login;
  bool get isSignup => _mode == AuthMode.Signup;
  bool isRecover = false;

  AuthMode opposite() {
    return _mode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
  }

  AuthMode switchAuth() {
    if (mode == AuthMode.Login) {
      mode = AuthMode.Signup;
    } else if (mode == AuthMode.Signup) {
      mode = AuthMode.Login;
    }
    return mode;
  }

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String _zomra = '';
  String get zomra => _zomra;
  set zomra(String zomra) {
    _zomra = zomra;
    notifyListeners();
  }

  String _wilaya = '';
  String get wilaya => _wilaya;
  set wilaya(String wilaya) {
    _wilaya = wilaya;
    notifyListeners();
  }

  String _address = '';
  String get address => _address;
  set address(String address) {
    _address = address;
    notifyListeners();
  }
}
