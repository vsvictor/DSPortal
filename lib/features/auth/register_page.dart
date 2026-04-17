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
              contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
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
              contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
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
                (value == null || value.length < 8)
                ? 'Пароль має містити щонайменше 8 символів'
                : null,
          ),
          SizedBox(height: spacing),
          TextFormField(
            controller: _repeatPasswordController,
            style: TextStyle(fontSize: isMobile ? 14 : null),
            obscureText: _isRepeatPasswordHidden,
            decoration: InputDecoration(
              labelText: 'Повторіть пароль',
              contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
              suffixIcon: IconButton(
                tooltip: _isRepeatPasswordHidden
                    ? 'Показати пароль'
                    : 'Сховати пароль',
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
                style: isMobile ? null : FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18)),
                child: const Text('Реєстрація', style: TextStyle(fontSize: 16)),
              ),
              OutlinedButton(
                onPressed: _openLogin,
                style: isMobile ? null : OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18)),
                child: const Text('Відмінити', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
