import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'http_client_factory.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Автентифікація',
      body: LoginForm(redirectTo: redirectTo),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.redirectTo,
    this.onAuthenticated,
    this.onRegisterRequested,
  });

  final String? redirectTo;
  final VoidCallback? onAuthenticated;
  final VoidCallback? onRegisterRequested;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'admin@admin.com');
  final TextEditingController _passwordController = TextEditingController(text: 'change-me');
  String? _errorText;
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String? error = await _sendAuthRequest(_emailController.text, _passwordController.text);

    if (!mounted) return;

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    // AuthState вже оновлено всередині _sendAuthRequest

    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    final String target = widget.redirectTo ?? AppRoutes.cabinet;
    Navigator.pushNamedAndRemoveUntil(
      context,
      target,
      (Route<dynamic> route) => route.settings.name == AppRoutes.home,
    );
  }

  Future<String?> _sendAuthRequest(String email, String password) async {
    const String baseUrl = 'https://mobilespace.dev:7443';
    final Uri url = Uri.parse('$baseUrl/auth/login');

    final Map<String, String> body = {
      'username': email,
      'password': password,
    };
    final String jsonBody = jsonEncode(body);

    http.Client? client;
    try {
      client = createHttpClient();

      final http.Response response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Успішний логін
        final data = jsonDecode(response.body);
        final String accessToken = data['access_token'];
        final String refreshToken = data['refresh_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        // Розбір JWT (payload - друга частина)
        final parts = accessToken.split('.');
        if (parts.length != 3) {
          return 'Невалідний токен';
        }

        final payloadPart = parts[1];
        final String normalized = base64Url.normalize(payloadPart);
        final String decodedPayload = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> payload = jsonDecode(decodedPayload);

        final id = payload['id'];
        if (id == null) {
          return 'ID не знайдено в токені';
        }

        // Отримання профілю
        final Uri profileUrl = Uri.parse('$baseUrl/profile/$id');
        final http.Response profileResponse = await client.get(
          profileUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (profileResponse.statusCode == 200) {
          debugPrint('Профіль успішно отримано: ${profileResponse.body}');

          if (mounted) {
            final auth = AuthScope.of(context);
            auth.setAuthenticatedUser(email, jsonDecode(utf8.decode(profileResponse.bodyBytes)));
          }
        } else {
          return 'Помилка отримання профілю (Код: ${profileResponse.statusCode})';
        }

        debugPrint('Отримано токен: $accessToken');
        return null; // Немає помилок
      } else {
        return 'Невірний e-mail або пароль (Код: ${response.statusCode})';
      }
    } catch (e) {
      debugPrint('\n--- Помилка виконання HTTP/3 запиту ---');
      debugPrint(e.toString());
      return 'Помилка з\'єднання з сервером';
    } finally {
      client?.close();
    }
  }

  void _openRegister() {
    if (widget.onRegisterRequested != null) {
      widget.onRegisterRequested!();
      return;
    }

    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS;
    final double spacing = isMobile ? 8 : 16;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            style: TextStyle(fontSize: isMobile ? 14 : null),
            decoration: InputDecoration(
              labelText: 'E-mail',
              contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12) : null,
            ),
            validator: (String? value) =>
                (value == null || !value.contains('@'))
                ? 'Вкажіть коректний e-mail'
                : null,
          ),
          SizedBox(height: spacing),
          TextFormField(
            controller: _passwordController,
            style: TextStyle(fontSize: isMobile ? 14 : null),
            obscureText: _isPasswordHidden,
            decoration: InputDecoration(
              labelText: 'Пароль',
              contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12) : null,
              suffixIcon: IconButton(
                tooltip: _isPasswordHidden ? 'Показати пароль' : 'Сховати пароль',
                onPressed: () {
                  setState(() => _isPasswordHidden = !_isPasswordHidden);
                },
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            validator: (String? value) =>
                (value == null || value.isEmpty) ? 'Вкажіть пароль' : null,
          ),
          if (_errorText != null) ...<Widget>[
            SizedBox(height: spacing),
            Text(
              _errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          SizedBox(height: spacing),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: <Widget>[
              FilledButton(
                onPressed: _submit,
                style: isMobile ? null : FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18)),
                child: const Text('Увійти', style: TextStyle(fontSize: 16)),
              ),
              OutlinedButton(
                onPressed: _openRegister,
                style: isMobile ? null : OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18)),
                child: const Text('Реєстрація', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
