import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_client_factory.dart';

class AuthController extends ChangeNotifier {
  final Map<String, String> _users = <String, String>{
    'demo@digital.gov.ua': 'Digital2026!',
  };

  String? _currentUserEmail;
  Map<String, dynamic>? _userProfile;
  bool _isInitialized = false;

  bool get isAuthenticated => _currentUserEmail != null;
  String? get currentUserEmail => _currentUserEmail;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isInitialized => _isInitialized;

  AuthController() {
    _initSession();
  }

  Future<void> _initSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken != null) {
        final parts = accessToken.split('.');
        if (parts.length == 3) {
          final payloadPart = parts[1];
          final String normalized = base64Url.normalize(payloadPart);
          final String decodedPayload = utf8.decode(base64Url.decode(normalized));
          final Map<String, dynamic> payload = jsonDecode(decodedPayload);

          final String email = payload['sub'] ?? 'User';
          final id = payload['id'];

          _currentUserEmail = email;

          if (id != null) {
            await _fetchProfile(id, accessToken);
          }
        }
      }
    } catch (e) {
      debugPrint('Помилка відновлення сесії: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _fetchProfile(dynamic id, String accessToken) async {
    http.Client? client;
    try {
      client = createHttpClient();
      final Uri profileUrl = Uri.parse('https://mobilespace.dev:7443/profile/$id');
      final response = await client.get(
        profileUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        _userProfile = jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint('Помилка отримання профілю: $e');
    } finally {
      client?.close();
    }
  }

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

  void logout() async {
    // Зберігаємо токен для відправки запиту перед очищенням
    String? oldToken;
    try {
      final prefs = await SharedPreferences.getInstance();
      oldToken = prefs.getString('access_token');
    } catch (_) {}

    _currentUserEmail = null;
    _userProfile = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
    } catch (e) {
      debugPrint('Помилка видалення токенів: $e');
    }

    notifyListeners();

    // Відправляємо запит на бекенд для інвалідації токена
    if (oldToken != null) {
      http.Client? client;
      try {
        client = createHttpClient();
        final Uri logoutUrl = Uri.parse('https://mobilespace.dev:7443/auth/logout');
        await client.post( // Або client.get / client.delete, залежно від API
          logoutUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $oldToken',
          },
        );
        debugPrint('Запит на auth/logout успішно відправлено');
      } catch (e) {
        debugPrint('Помилка відправки запиту logout: $e');
      } finally {
        client?.close();
      }
    }
  }

  // Додатковий метод на випадок, якщо потрібен логін вже з токеном з login_page.dart
  void setAuthenticatedUser(String email, [Map<String, dynamic>? profile]) {
    _currentUserEmail = email;
    _userProfile = profile;
    notifyListeners();
  }
}
