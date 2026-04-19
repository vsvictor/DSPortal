import 'package:dsportal/app/routes.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/features/auth/login_page.dart';
import 'package:dsportal/features/auth/register_page.dart';
import 'package:flutter/foundation.dart';
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
      final bool isMobile = Theme.of(modalContext).platform == TargetPlatform.android || Theme.of(modalContext).platform == TargetPlatform.iOS;

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: MediaQuery.sizeOf(modalContext).height * 0.98,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, isMobile ? 10 : 20, 20, 20),
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
    if (!kIsWeb) {
      Navigator.pushNamed(context, AppRoutes.cabinet);
    }
    return;
  }

  final bool? isLoggedIn = await showLoginModal(context);
  if (isLoggedIn == true && context.mounted) {
    if (!kIsWeb) {
      Navigator.pushNamed(context, AppRoutes.cabinet);
    }
  }
}

class _LoginModalContent extends StatelessWidget {
  const _LoginModalContent();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Автентифікація',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: isMobile ? 18 : null,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 16),
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
    final bool isMobile = Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Реєстрація',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: isMobile ? 18 : null,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 16),
          RegisterForm(
            onAuthenticated: () {
              final NavigatorState rootNavigator = Navigator.of(
                context,
                rootNavigator: true,
              );
              rootNavigator.pop(true);
              if (!kIsWeb) {
                rootNavigator.pushNamed(AppRoutes.cabinet);
              }
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
