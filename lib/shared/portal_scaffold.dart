import 'package:dsportal/app/routes.dart';
import 'package:dsportal/core/theme.dart';
import 'package:dsportal/features/auth/auth_modal.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:flutter/material.dart';

class PortalScaffold extends StatelessWidget {
  const PortalScaffold({
    super.key,
    required this.title,
    required this.body,
    this.currentRoute,
  });

  final String title;
  final Widget body;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            if (Navigator.of(context).canPop()) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Назад',
              );
            }

            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Меню',
            );
          },
        ),
        title: const Text('ДП "Цифрове" — портал Міністерства економіки'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Column(
            children: const <Widget>[
              SizedBox(height: 4, width: double.infinity, child: ColoredBox(color: DsColors.blue)),
              SizedBox(height: 4, width: double.infinity, child: ColoredBox(color: DsColors.yellow)),
            ],
          ),
        ),
      ),
      drawer: PortalDrawer(currentRoute: currentRoute),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  body,
                ],
              ),
            ),
          ),
          const PortalFooter(),
        ],
      ),
    );
  }
}

class PortalDrawer extends StatelessWidget {
  const PortalDrawer({super.key, this.currentRoute});

  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: DsColors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Icon(Icons.account_balance, color: Colors.white, size: 34),
                SizedBox(height: 8),
                Text(
                  'Головний портал',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 6),
                Text(
                  'ДП "Цифрове"',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ...publicSections.map(
            (PublicSection section) => ListTile(
              selected: currentRoute == section.route,
              title: Text(section.title),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != section.route) {
                  Navigator.pushNamed(context, section.route);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(auth.isAuthenticated ? 'Закрита частина' : 'Кабінет (вхід)'),
            onTap: () {
              Navigator.pop(context);
              openCabinetWithAuthModal(context);
            },
          ),
          if (auth.isAuthenticated)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Вийти'),
              onTap: () {
                auth.logout();
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (Route<dynamic> route) => false,
                );
              },
            ),
        ],
      ),
    );
  }
}

class PortalFooter extends StatelessWidget {
  const PortalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: const Text(
        'м. Київ, бульвар Лесі Українки, 26 • ДП "Цифрове" • © 2026',
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
  });

  final String title;
  final String content;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, color: DsColors.blue),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

