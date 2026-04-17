import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = AuthScope.of(context);
    final String? error = auth.login(
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

    final String target = widget.redirectTo ?? AppRoutes.cabinet;
    Navigator.pushNamedAndRemoveUntil(
      context,
      target,
      (Route<dynamic> route) => route.settings.name == AppRoutes.home,
    );
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
