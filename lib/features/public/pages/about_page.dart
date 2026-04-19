import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Про нас',
      showTitle: false,
      currentRoute: AppRoutes.about,
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: _AboutContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _LeftPanel()),
              const SizedBox(width: 48),
              Expanded(flex: 6, child: _RightPanel()),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LeftPanel(),
              const SizedBox(height: 48),
              _RightPanel(),
            ],
          );
        }
      },
    );
  }
}

class _LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'ПРО ПІДПРИЄМСТВО',
            style: TextStyle(
              color: Color(0xFF1955A5),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Провідний державний ІТ-партнер Міністерства економіки',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF15223A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'ДП «Цифрове» — державне підприємство, засноване Міністерством економіки України, що спеціалізується на розробці, впровадженні та супроводі інформаційних систем державного управління. З 2014 року ми є ключовим технологічним партнером Мінекономіки.',
          style: TextStyle(fontSize: 16, color: Color(0xFF5A657D), height: 1.6),
        ),
        const SizedBox(height: 16),
        const Text(
          'Наша місія — забезпечити надійну та сучасну цифрову інфраструктуру для ефективного функціонування органів державної влади та надання якісних послуг громадянам України.',
          style: TextStyle(fontSize: 16, color: Color(0xFF5A657D), height: 1.6),
        ),
        const SizedBox(height: 40),
        const _FeatureItem(
          icon: '🔒',
          title: 'Надійність і безпека',
          description:
              'Відповідність НД ТЗІ, ISO 27001 та державним стандартам захисту інформації',
        ),
        const SizedBox(height: 24),
        const _FeatureItem(
          icon: '⚡',
          title: 'Ефективність',
          description:
              'Agile-підходи та DevOps-практики для швидкого та якісного результату',
        ),
        const SizedBox(height: 24),
        const _FeatureItem(
          icon: '🤝',
          title: 'Прозорість',
          description:
              'Відкриті процеси, чітка звітність та дотримання принципів публічного управління',
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D5CBB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Зв'язатися з нами",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1D5CBB),
                side: const BorderSide(color: Color(0xFF1D5CBB), width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Наші послуги",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF718096),
                  height: 1.4,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallMobile = constraints.maxWidth < 360;
            final double spacing = 16.0;
            final double cardWidth = isSmallMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                _StatCard(
                  width: cardWidth,
                  value: '2014',
                  label: 'Рік заснування',
                ),
                _StatCard(
                  width: cardWidth,
                  value: '12',
                  label: 'Активних систем',
                ),
                _StatCard(
                  width: cardWidth,
                  value: '150+',
                  label: 'Фахівців',
                ),
                _StatCard(
                  width: cardWidth,
                  value: '30+',
                  label: 'Проєктів',
                ),
                _StatCard(
                  width: cardWidth,
                  value: '500+',
                  label: 'Держслужбовців\nобслуговуємо щодня',
                ),
                _StatCard(
                  width: cardWidth,
                  value: '99.9%',
                  label: 'Uptime систем',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const _CertificationsCard()
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final String value;
  final String label;

  const _StatCard({
    required this.width,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D5CBB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificationsCard extends StatelessWidget {
  const _CertificationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'СЕРТИФІКАТИ ТА СТАНДАРТИ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A5568),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _CertChip('ISO 27001'),
              _CertChip('ДСТУ ISO 9001'),
              _CertChip('НД ТЗІ'),
              _CertChip('КЗЗІ'),
            ],
          )
        ],
      ),
    );
  }
}

class _CertChip extends StatelessWidget {
  final String text;

  const _CertChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1D5CBB),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
