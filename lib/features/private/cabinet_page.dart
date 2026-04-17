import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class CabinetPage extends StatelessWidget {
  const CabinetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return PortalScaffold(
      title: 'Закрита частина порталу',
      currentRoute: AppRoutes.cabinet,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InfoCard(
            title: 'Авторизовано',
            content: 'Користувач: ${auth.currentUserEmail ?? '-'}',
            icon: Icons.verified,
          ),
          const InfoCard(
            title: 'Внутрішні модулі',
            content:
                '• Моніторинг інцидентів\n• Внутрішня документація\n• Реєстр службових звернень\n• Аналітичні звіти',
            icon: Icons.dashboard_customize,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () {
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Вийти з кабінету'),
            ),
          ),
        ],
      ),
    );
  }
}

