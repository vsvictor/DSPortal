import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final Map<String, String> _users = <String, String>{
    'demo@digital.gov.ua': 'Digital2026!',
  };

  String? _currentUserEmail;

  bool get isAuthenticated => _currentUserEmail != null;
  String? get currentUserEmail => _currentUserEmail;

  String? login({required String email, required String password}) {
    final String normalizedEmail = email.trim().toLowerCase();
    final String? storedPassword = _users[normalizedEmail];

    if (storedPassword == null || storedPassword != password) {
      return 'Невірний e-mail або пароль.';
    }

    _currentUserEmail = normalizedEmail;
    notifyListeners();
    return null;
  }

  String? register({required String email, required String password}) {
    final String normalizedEmail = email.trim().toLowerCase();

    if (!normalizedEmail.contains('@')) {
      return 'Вкажіть коректний e-mail.';
    }
    if (password.length < 8) {
      return 'Пароль має містити щонайменше 8 символів.';
    }
    if (_users.containsKey(normalizedEmail)) {
      return 'Користувач з таким e-mail вже існує.';
    }

    _users[normalizedEmail] = password;
    _currentUserEmail = normalizedEmail;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUserEmail = null;
    notifyListeners();
  }
}

