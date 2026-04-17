import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Проекти',
      currentRoute: AppRoutes.projects,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Єдиний аналітичний кабінет',
            content:
                'Консолідація показників ефективності програм Міністерства економіки в одному інструменті.',
            icon: Icons.analytics,
          ),
          InfoCard(
            title: 'Платформа електронних сервісів',
            content:
                'Надання бізнесу та громадянам цифрових послуг з прозорими статусами обробки.',
            icon: Icons.public,
          ),
          InfoCard(
            title: 'Система інтеграцій',
            content:
                'Побудова захищеної шини обміну даними для державних інформаційних ресурсів.',
            icon: Icons.sync_alt,
          ),
        ],
      ),
    );
  }
}

