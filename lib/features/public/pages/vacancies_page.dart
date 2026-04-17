import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Вакансії',
      currentRoute: AppRoutes.vacancies,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Flutter Developer',
            content:
                'Розробка модулів електронних сервісів, інтеграція API, участь у проєктуванні архітектури.',
            icon: Icons.phone_iphone,
          ),
          InfoCard(
            title: 'DevOps Engineer',
            content:
                'Побудова CI/CD, керування інфраструктурою, підвищення надійності та безпеки середовищ.',
            icon: Icons.cloud,
          ),
          InfoCard(
            title: 'Business Analyst',
            content:
                'Аналіз вимог стейкхолдерів, моделювання процесів і формування технічних завдань.',
            icon: Icons.business_center,
          ),
        ],
      ),
    );
  }
}

