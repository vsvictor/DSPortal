import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/features/auth/login_page.dart';
import 'package:dsportal/features/auth/register_page.dart';
import 'package:flutter/material.dart';

Future<bool?> showLoginModal(BuildContext context) {
  return _showAuthDialog(
    context,
    const _LoginModalContent(),
  );
}

Future<bool?> showRegisterModal(BuildContext context) {
  return _showAuthDialog(
    context,
    const _RegisterModalContent(),
  );
}

Future<bool?> _showAuthDialog(BuildContext context, Widget child) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext modalContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: MediaQuery.sizeOf(modalContext).height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      );
    },
  );
}

Future<void> openCabinetWithAuthModal(BuildContext context) async {
  final auth = AuthScope.of(context);
  if (auth.isAuthenticated) {
    Navigator.pushNamed(context, AppRoutes.cabinet);
    return;
  }

  final bool? isLoggedIn = await showLoginModal(context);
  if (isLoggedIn == true && context.mounted) {
    Navigator.pushNamed(context, AppRoutes.cabinet);
  }
}

class _LoginModalContent extends StatelessWidget {
  const _LoginModalContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Автентифікація',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LoginForm(
            onAuthenticated: () => Navigator.of(context).pop(true),
            onRegisterRequested: () {
              final NavigatorState rootNavigator = Navigator.of(
                context,
                rootNavigator: true,
              );
              rootNavigator.pop(false);
              showRegisterModal(rootNavigator.context);
            },
          ),
        ],
      ),
    );
  }
}

class _RegisterModalContent extends StatelessWidget {
  const _RegisterModalContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Реєстрація',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          RegisterForm(
            onAuthenticated: () {
              final NavigatorState rootNavigator = Navigator.of(
                context,
                rootNavigator: true,
              );
              rootNavigator.pop(true);
              rootNavigator.pushNamed(AppRoutes.cabinet);
            },
            onLoginRequested: () {
              final NavigatorState rootNavigator = Navigator.of(
                context,
                rootNavigator: true,
              );
              rootNavigator.pop(false);
              showLoginModal(rootNavigator.context);
            },
          ),
        ],
      ),
    );
  }
}
