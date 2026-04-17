import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    final String? error = auth.register(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.cabinet,
      (Route<dynamic> route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Реєстрація користувача',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  (value == null || value.length < 8)
                  ? 'Пароль має містити щонайменше 8 символів'
                  : null,
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
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Створити акаунт'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final bool popped = await Navigator.of(context).maybePop();
                    if (!popped && context.mounted) {
                      Navigator.pushNamed(context, AppRoutes.login);
                    }
                  },
                  child: const Text('Назад до входу'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

