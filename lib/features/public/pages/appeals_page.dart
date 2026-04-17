import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class AppealsPage extends StatefulWidget {
  const AppealsPage({super.key});

  @override
  State<AppealsPage> createState() => _AppealsPageState();
}

class _AppealsPageState extends State<AppealsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Звернення прийнято. Ми відповімо на вказаний e-mail.'),
      ),
    );

    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Звернення',
      currentRoute: AppRoutes.appeals,
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ПІБ'),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty)
                  ? 'Вкажіть ваше ім\'я'
                  : null,
            ),
            const SizedBox(height: 12),
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
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Текст звернення'),
              validator: (String? value) =>
                  (value == null || value.trim().length < 10)
                  ? 'Повідомлення має містити щонайменше 10 символів'
                  : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Надіслати'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

