import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

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

    final String target = widget.redirectTo ?? AppRoutes.cabinet;
    Navigator.pushNamedAndRemoveUntil(
      context,
      target,
      (Route<dynamic> route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Вхід до закритої частини',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const InfoCard(
              title: 'Демо-доступ',
              content: 'E-mail: demo@digital.gov.ua\nПароль: Digital2026!',
              icon: Icons.info,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              validator: (String? value) =>
                  (value == null || !value.contains('@'))
                  ? 'Вкажіть коректний e-mail'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
              validator: (String? value) =>
                  (value == null || value.isEmpty) ? 'Вкажіть пароль' : null,
            ),
            if (_errorText != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: <Widget>[
                FilledButton(onPressed: _submit, child: const Text('Увійти')),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  child: const Text('Реєстрація'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

