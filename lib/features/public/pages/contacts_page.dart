import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Контакти',
      currentRoute: AppRoutes.contacts,
      body: Column(
        children: <Widget>[
          InfoCard(
            title: 'Адреса',
            content: 'м. Київ, бульвар Лесі Українки, 26',
            icon: Icons.location_city,
          ),
          InfoCard(
            title: 'Приймальня',
            content: '+380 (44) 000-00-00\ninfo@digital.gov.ua',
            icon: Icons.call,
          ),
          InfoCard(
            title: 'Графік роботи',
            content: 'Пн-Пт: 09:00-18:00\nСб-Нд: вихідні',
            icon: Icons.schedule,
          ),
        ],
      ),
    );
  }
}

