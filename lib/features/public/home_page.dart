import 'package:dsportal/app/routes.dart';
import 'package:dsportal/core/theme.dart';
import 'package:dsportal/features/auth/auth_scope.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Helpers ────────────────────────────────────────────────────────────────────
// "мобільні" = тільки Android та iOS
bool get _isMobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);


// "desktop"  = macOS, Windows, Linux
bool get _isDesktopOS =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux);
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double desktopBreakpoint = 1000;

    return Scaffold(
      backgroundColor: DsColors.blue,
      drawer: const PortalDrawer(currentRoute: AppRoutes.home),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isDesktop = constraints.maxWidth >= desktopBreakpoint;
            // Мобільний top-row (badge + меню) — тільки Android/iOS і не широкий екран
            final bool showNativeTopRow = _isMobile && !isDesktop;
            // Desktop top-row (badge + меню) — macOS/Windows/Linux на вузькому екрані
            final bool showDesktopTopRow = _isDesktopOS && !isDesktop;
            final double topOffset = MediaQuery.sizeOf(context).height * 0.015;
            final double horizontalInset =
                showNativeTopRow ? MediaQuery.sizeOf(context).width * 0.03 : 20;

            final Widget introContent = _HeroIntroContent(
              showInlineBadge: !showNativeTopRow && !showDesktopTopRow,
              isMobile: showNativeTopRow,
              showStandaloneMenu: !isDesktop && !showNativeTopRow && !showDesktopTopRow,
            );

            final Widget heroContent = showNativeTopRow
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalInset,
                      12,
                      horizontalInset,
                      20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 780),
                              child: introContent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _StatsCard(isMobile: true),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 980),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalInset,
                            showDesktopTopRow ? 12 : (isDesktop ? 34 : 18),
                            horizontalInset,
                            40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: showDesktopTopRow ? 12 : 20),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 780),
                                child: introContent,
                              ),
                              const SizedBox(height: 72),
                              const _StatsCard(isMobile: false),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

            if (isDesktop) {
              return Column(
                children: <Widget>[
                  const _DesktopTopHeader(),
                  Expanded(child: heroContent),
                ],
              );
            }

            if (showNativeTopRow) {
              return Column(
                children: <Widget>[
                  _NativeTopRow(topOffset: topOffset),
                  Expanded(child: heroContent),
                ],
              );
            }

            if (showDesktopTopRow) {
              return Column(
                children: <Widget>[
                  _DesktopNarrowTopRow(topOffset: topOffset),
                  Expanded(child: heroContent),
                ],
              );
            }

            return heroContent;
          },
        ),
      ),
    );
  }
}

class _HeroIntroContent extends StatelessWidget {
  const _HeroIntroContent({
    required this.showInlineBadge,
    required this.isMobile,
    required this.showStandaloneMenu,
  });

  final bool showInlineBadge;
  final bool isMobile;
  final bool showStandaloneMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showStandaloneMenu)
          Align(
            alignment: Alignment.centerRight,
            child: Builder(
              builder: (BuildContext context) {
                return IconButton.filledTonal(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                  ),
                  icon: const Icon(Icons.menu, color: Colors.white),
                );
              },
            ),
          ),
        SizedBox(height: showStandaloneMenu ? 20 : 0),
        if (showInlineBadge) ...<Widget>[
          const SizedBox(height: 20),
          const _EnterpriseBadge(),
          const SizedBox(height: 30),
        ],
        _HeroTitle(isMobile: isMobile),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.07),
        Text(
          'Розробляємо та супроводжуємо критично важливі '
          'інформаційні системи Міністерства економіки України. '
          'Ваша держава — цифрова.',
          maxLines: isMobile ? 3 : null,
          overflow: isMobile ? TextOverflow.ellipsis : TextOverflow.visible,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
            height: 1.6,
            fontWeight: FontWeight.w400,
            fontSize: isMobile ? 15 : null,
          ),
        ),
        const SizedBox(height: 34),
        _HeroActions(isMobile: isMobile),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('hero-stats-card'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 16,
        vertical: isMobile ? 16 : 20,
      ),
      child: _StatsPanel(isMobile: isMobile),
    );
  }
}

/// Фіксований header для desktop (macOS/Windows/Linux) на вузькому екрані:
/// badge по ширині тексту + кнопка меню, вирівняні в один ряд.
class _DesktopNarrowTopRow extends StatelessWidget {
  const _DesktopNarrowTopRow({required this.topOffset});

  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topOffset, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton.filledTonal(
                onPressed: () => Scaffold.of(context).openDrawer(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.14),
                ),
                icon: const Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
          const Spacer(),
          const _EnterpriseBadge(), // повний текст за замовчуванням
        ],
      ),
    );
  }
}

class _NativeTopRow extends StatelessWidget {
  const _NativeTopRow({required this.topOffset});

  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topOffset, 20, 8),
      child: Row(
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton.filledTonal(
                onPressed: () => Scaffold.of(context).openDrawer(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.14),
                ),
                icon: const Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
          const Spacer(),
          const _EnterpriseBadge(label: 'ДП «Цифрове»'),
        ],
      ),
    );
  }
}

/// Заголовок hero-секції.
/// На мобільних (Android/iOS) кожен рядок масштабується через [FittedBox]
/// так, щоб займав одну строку з відступами 3% від ширини вікна.
class _HeroTitle extends StatelessWidget {
  const _HeroTitle({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final TextStyle? base = Theme.of(context).textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.w800,
      height: 1.15,
    );

    if (!isMobile) {
      // desktop / web — як раніше, без масштабування
      return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: 'Цифрова трансформація\n',
              style: base?.copyWith(color: Colors.white),
            ),
            TextSpan(
              text: 'державних послуг',
              style: base?.copyWith(color: DsColors.yellow),
            ),
          ],
        ),
      );
    }

    // Мобільний варіант: кожен рядок займає одну строку завдяки FittedBox.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Цифрова трансформація',
            style: base?.copyWith(color: Colors.white),
            maxLines: 1,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'державних послуг',
            style: base?.copyWith(color: DsColors.yellow),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (!isMobile) {
      return Wrap(
        spacing: 14,
        runSpacing: 12,
        children: <Widget>[
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: DsColors.yellow,
              foregroundColor: const Color(0xFF132238),
              padding: const EdgeInsets.symmetric(
                horizontal: 34,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
            child: const Text(
              'Наші послуги',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.45),
              ),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 34,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
            child: const Text(
              'Зв\'язатися з нами',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: DsColors.yellow,
              foregroundColor: const Color(0xFF132238),
              minimumSize: const Size.fromHeight(60),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Наші послуги',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.45),
              ),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(60),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Зв\'язатися з нами',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EnterpriseBadge extends StatelessWidget {
  const _EnterpriseBadge({
    this.label = 'Державне підприємство «Цифрове»',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.circle, size: 8, color: DsColors.yellow),
          const SizedBox(width: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DesktopTopHeader extends StatelessWidget {
  const _DesktopTopHeader();

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Row(
            children: <Widget>[
              const _HeaderBrand(),
              const SizedBox(width: 18),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: publicSections
                        .map(
                          (PublicSection section) => _TopNavLink(
                            label: section.title,
                            onTap: () => Navigator.pushNamed(
                              context,
                              section.route,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cabinet),
                style: FilledButton.styleFrom(
                  backgroundColor: DsColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(auth.isAuthenticated ? 'Кабінет' : 'Увійти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBrand extends StatelessWidget {
  const _HeaderBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: DsColors.blue,
          ),
          child: const Icon(
            Icons.account_balance,
            color: DsColors.yellow,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'ДП «Цифрове»',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DsColors.blue,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              'Цифрова держава\nМінекономіки України',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF3E4A63),
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopNavLink extends StatelessWidget {
  const _TopNavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF4A566E),
      ),
      child: Text(label),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    const List<({String value, String label})> stats = <({
      String value,
      String label,
    })>[
      (value: '10+', label: 'років досвіду'),
      (value: '30+', label: 'реалізованих проєктів'),
      (value: '150+', label: 'фахівців у команді'),
      (value: '99.9%', label: 'uptime систем'),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 700;

        if (isMobile) {
          return Row(
            children: <Widget>[
              for (int index = 0; index < stats.length; index++) ...<Widget>[
                Expanded(
                  child: _StatTile(
                    value: stats[index].value,
                    label: stats[index].label,
                    compact: isMobile,
                  ),
                ),
                if (index != stats.length - 1)
                  Container(
                    width: 1,
                    height: isMobile ? 52 : 40,
                    color: Colors.white.withValues(alpha: 0.17),
                  ),
              ],
            ],
          );
        }

        if (compact) {
          return Wrap(
            runSpacing: 18,
            spacing: 20,
            children: stats
                .map(
                  (({String value, String label}) stat) => SizedBox(
                    width: 150,
                    child: _StatTile(
                      value: stat.value,
                      label: stat.label,
                      compact: false,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: <Widget>[
            for (int index = 0; index < stats.length; index++) ...<Widget>[
              Expanded(
                child: _StatTile(
                  value: stats[index].value,
                  label: stats[index].label,
                  compact: false,
                ),
              ),
              if (index != stats.length - 1)
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.17),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.compact,
  });

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: compact ? 40 : null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: (compact
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.headlineMedium)
                      ?.copyWith(
                        color: DsColors.yellow,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: (compact
                    ? Theme.of(context).textTheme.bodySmall
                    : Theme.of(context).textTheme.bodyLarge)
                ?.copyWith(
                  color: Colors.white.withValues(alpha: 0.68),
                  height: compact ? 1.25 : null,
                ),
          ),
        ],
      ),
    );
  }
}
