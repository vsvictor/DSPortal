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
                (value == null || value.isEmpty) ? 'Вкажіть пароль' : null,
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
                    'Увійти',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _openRegister,
                  child: const Text(
                    'Реєстрація',
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
