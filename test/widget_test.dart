import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dsportal/app/app.dart';
import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_controller.dart';

void main() {
  testWidgets('Portal home hero renders and services CTA navigates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DSPortalApp(authController: AuthController()));

    expect(find.text('ДП «Цифрове»'), findsOneWidget);
    expect(find.textContaining('критично важливі'), findsOneWidget);
    expect(find.text('Наші послуги'), findsOneWidget);
    expect(find.text('Зв\'язатися з нами'), findsOneWidget);
    expect(find.text('99.9%'), findsOneWidget);

    await tester.tap(find.text('Наші послуги'));
    await tester.pumpAndSettle();

    expect(find.text('Послуги'), findsOneWidget);
    expect(find.text('Розробка ПЗ'), findsOneWidget);
  });

  testWidgets('Mobile CTA buttons stay on one row with 3 percent side margins', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(DSPortalApp(authController: AuthController()));

    final Rect servicesRect = tester.getRect(
      find.widgetWithText(FilledButton, 'Наші послуги'),
    );
    final Rect contactsRect = tester.getRect(
      find.widgetWithText(OutlinedButton, 'Зв\'язатися з нами'),
    );

    final double expectedInset = 390 * 0.03;

    expect((servicesRect.top - contactsRect.top).abs(), lessThanOrEqualTo(1));
    expect(servicesRect.left, closeTo(expectedInset, 2));
    expect(contactsRect.right, closeTo(390 - expectedInset, 2));
    expect(servicesRect.right, lessThan(contactsRect.left));
  });

  testWidgets('Mobile stats card stays on one row and near the bottom', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(DSPortalApp(authController: AuthController()));

    final Rect statsCardRect = tester.getRect(
      find.byKey(const ValueKey<String>('hero-stats-card')),
    );
    final Rect stat1 = tester.getRect(find.text('10+'));
    final Rect stat2 = tester.getRect(find.text('30+'));
    final Rect stat3 = tester.getRect(find.text('150+'));
    final Rect stat4 = tester.getRect(find.text('99.9%'));

    expect((stat1.center.dy - stat2.center.dy).abs(), lessThanOrEqualTo(5));
    expect((stat1.center.dy - stat3.center.dy).abs(), lessThanOrEqualTo(5));
    expect((stat1.center.dy - stat4.center.dy).abs(), lessThanOrEqualTo(5));
    expect(statsCardRect.bottom, closeTo(844 - 20, 8));
  });

  testWidgets('All public sections open on separate pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DSPortalApp(authController: AuthController()));

    final NavigatorState navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );

    const List<({String route, String title})> sections = <({
      String route,
      String title,
    })>[
      (route: AppRoutes.about, title: 'Про нас'),
      (route: AppRoutes.services, title: 'Послуги'),
      (route: AppRoutes.projects, title: 'Проекти'),
      (route: AppRoutes.news, title: 'Новини'),
      (route: AppRoutes.vacancies, title: 'Вакансії'),
      (route: AppRoutes.appeals, title: 'Звернення'),
      (route: AppRoutes.contacts, title: 'Контакти'),
    ];

    for (final ({String route, String title}) section in sections) {
      navigator.pushNamed(section.route);
      await tester.pumpAndSettle();
      expect(find.text(section.title), findsWidgets);

      navigator.pop();
      await tester.pumpAndSettle();
    }
  });
}
