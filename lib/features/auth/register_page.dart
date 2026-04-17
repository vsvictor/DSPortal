import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Реєстрація',
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    this.onAuthenticated,
    this.onLoginRequested,
  });

  final VoidCallback? onAuthenticated;
  final VoidCallback? onLoginRequested;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  String? _errorText;
  bool _isPasswordHidden = true;
  bool _isRepeatPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = AuthScope.of(context);
    final String? error = auth.register(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.cabinet,
      (Route<dynamic> route) => route.settings.name == AppRoutes.home,
    );
  }

  void _openLogin() {
    if (widget.onLoginRequested != null) {
      widget.onLoginRequested!();
      return;
    }

    Navigator.of(context).maybePop().then((bool popped) {
      if (!popped && mounted) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            ),
            validator: (String? value) =>
                (value == null || !value.contains('@'))
                ? 'Вкажіть коректний e-mail'
                : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            decoration: InputDecoration(
              labelText: 'Пароль',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              suffixIcon: IconButton(
                tooltip: _isPasswordHidden ? 'Показати пароль' : 'Сховати пароль',
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() => _isPasswordHidden = !_isPasswordHidden);
                },
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            validator: (String? value) =>
                (value == null || value.length < 8)
                ? 'Пароль має містити щонайменше 8 символів'
                : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _repeatPasswordController,
            obscureText: _isRepeatPasswordHidden,
            decoration: InputDecoration(
              labelText: 'Повторіть пароль',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              suffixIcon: IconButton(
                tooltip: _isRepeatPasswordHidden
                    ? 'Показати пароль'
                    : 'Сховати пароль',
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(
                    () => _isRepeatPasswordHidden = !_isRepeatPasswordHidden,
                  );
                },
                icon: Icon(
                  _isRepeatPasswordHidden
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Повторіть пароль';
              }
              if (value != _passwordController.text) {
                return 'Паролі не збігаються';
              }
              return null;
            },
          ),
          if (_errorText != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text(
                    'Реєстрація',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _openLogin,
                  child: const Text(
                    'Відмінити',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
