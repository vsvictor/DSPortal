import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Послуги',
      currentRoute: AppRoutes.services,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Розробка ПЗ',
            content:
                'Проєктування, створення та масштабування державних інформаційних систем для різних типів користувачів.',
            icon: Icons.code,
          ),
          InfoCard(
            title: 'Підтримка 24/7',
            content:
                'Моніторинг, реагування на інциденти, забезпечення стабільної роботи критичної ІТ-інфраструктури.',
            icon: Icons.support_agent,
          ),
          InfoCard(
            title: 'Інтеграція',
            content:
                'Обмін даними між державними реєстрами, API-взаємодія та автоматизація міжвідомчих процесів.',
            icon: Icons.hub,
          ),
        ],
      ),
    );
  }
}

