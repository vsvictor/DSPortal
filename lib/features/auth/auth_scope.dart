import 'package:dsportal/features/auth/auth_controller.dart';
import 'package:flutter/widgets.dart';

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController super.notifier,
    required super.child,
  });

  static AuthController of(BuildContext context) {
    final AuthScope? scope =
        context.dependOnInheritedWidgetOfExactType<AuthScope>();

    assert(scope != null, 'AuthScope не знайдено у дереві віджетів.');
    return scope!.notifier!;
  }
}

