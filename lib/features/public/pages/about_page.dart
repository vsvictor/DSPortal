import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Про нас',
      currentRoute: AppRoutes.about,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Місія підприємства',
            content:
                'ДП "Цифрове" забезпечує створення, розвиток і супровід цифрових платформ для Міністерства економіки України.',
            icon: Icons.verified_user,
          ),
          InfoCard(
            title: 'Ключові напрямки',
            content:
                'Розробка реєстрів, інтеграція державних даних, аналітичні панелі, інформаційна безпека, технічна підтримка.',
            icon: Icons.settings_suggest,
          ),
        ],
      ),
    );
  }
}

