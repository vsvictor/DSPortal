import 'package:dsportal/app/routes.dart';
import 'package:dsportal/core/theme.dart';
import 'package:dsportal/features/auth/auth_controller.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/features/auth/login_page.dart';
import 'package:dsportal/features/auth/register_page.dart';
import 'package:dsportal/features/private/cabinet_page.dart';
import 'package:dsportal/features/public/home_page.dart';
import 'package:dsportal/features/public/pages/about_page.dart';
import 'package:dsportal/features/public/pages/appeals_page.dart';
import 'package:dsportal/features/public/pages/contacts_page.dart';
import 'package:dsportal/features/public/pages/news_page.dart';
import 'package:dsportal/features/public/pages/projects_page.dart';
import 'package:dsportal/features/public/pages/services_page.dart';
import 'package:dsportal/features/public/pages/vacancies_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool get _isMobilePlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

class DSPortalApp extends StatelessWidget {
  const DSPortalApp({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      notifier: authController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Портал ДП "Цифрове"',
        theme: buildPortalTheme(),
        builder: (BuildContext context, Widget? child) {
          if (!_isMobilePlatform) {
            return child ?? const SizedBox.shrink();
          }

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
              systemNavigationBarContrastEnforced: false,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        initialRoute: AppRoutes.home,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AppRoutes.home:
              return MaterialPageRoute<void>(builder: (_) => const HomePage());
            case AppRoutes.about:
              return MaterialPageRoute<void>(builder: (_) => const AboutPage());
            case AppRoutes.services:
              return MaterialPageRoute<void>(
                builder: (_) => const ServicesPage(),
              );
            case AppRoutes.projects:
              return MaterialPageRoute<void>(builder: (_) => const ProjectsPage());
            case AppRoutes.news:
              return MaterialPageRoute<void>(builder: (_) => const NewsPage());
            case AppRoutes.vacancies:
              return MaterialPageRoute<void>(
                builder: (_) => const VacanciesPage(),
              );
            case AppRoutes.appeals:
              return MaterialPageRoute<void>(
                builder: (_) => const AppealsPage(),
              );
            case AppRoutes.contacts:
              return MaterialPageRoute<void>(
                builder: (_) => const ContactsPage(),
              );
            case AppRoutes.login:
              final String? redirectTo = settings.arguments as String?;
              return MaterialPageRoute<void>(
                builder: (_) => LoginPage(redirectTo: redirectTo),
              );
            case AppRoutes.register:
              return MaterialPageRoute<void>(
                builder: (_) => const RegisterPage(),
              );
            case AppRoutes.cabinet:
              if (!authController.isAuthenticated) {
                return MaterialPageRoute<void>(
                  builder: (_) => const LoginPage(redirectTo: AppRoutes.cabinet),
                );
              }
              return MaterialPageRoute<void>(
                builder: (_) => const CabinetPage(),
              );
            default:
              return MaterialPageRoute<void>(
                builder: (_) => const HomePage(),
              );
          }
        },
      ),
    );
  }
}

