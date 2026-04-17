import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Новини',
      currentRoute: AppRoutes.news,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Квітень 2026',
            content:
                'Запущено оновлений модуль моніторингу звернень, що скоротив час опрацювання на 35%.',
            icon: Icons.newspaper,
          ),
          InfoCard(
            title: 'Березень 2026',
            content:
                'Розпочато пілот інтеграції реєстрів для автоматизації міжвідомчих перевірок.',
            icon: Icons.announcement,
          ),
          InfoCard(
            title: 'Лютий 2026',
            content:
                'Команда ДП "Цифрове" пройшла державний аудит інформаційної безпеки без критичних зауважень.',
            icon: Icons.security,
          ),
        ],
      ),
    );
  }
}

