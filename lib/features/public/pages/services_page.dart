import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortalScaffold(
      title: 'Послуги',
      showTitle: false,
      currentRoute: AppRoutes.services,
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const _ServicesContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ServicesHeader(),
        const SizedBox(height: 48),
        _ServicesGrid(),
      ],
    );
  }
}

class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'ПОСЛУГИ',
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
          'Що ми робимо',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF15223A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Повний цикл розробки та підтримки державних IT-систем — від\nаналізу вимог до промислової експлуатації',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF5A657D),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing = 24.0;
        int columns = 1;
        if (constraints.maxWidth >= 900) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: [
            _ServiceCard(
              width: cardWidth,
              icon: '💻', // using emoji as placeholder for image
              title: 'Розробка програмного забезпечення',
              description: 'Повний цикл розробки державних інформаційних систем: від технічного завдання до здачі в експлуатацію.',
              features: const [
                'Веб-додатки та API',
                'Мікросервісна архітектура',
                'Agile та Scrum методології',
                'Code review та QA',
              ],
            ),
            _ServiceCard(
              width: cardWidth,
              icon: '🛡️',
              title: 'Кібербезпека та захист даних',
              description: 'Комплексний захист інформаційних систем відповідно до вимог НД ТЗІ та КЗЗІ.',
              features: const [
                'Аудит безпеки систем',
                'Впровадження КЗЗІ',
                'Пентестування',
                'Навчання персоналу',
              ],
            ),
            _ServiceCard(
              width: cardWidth,
              icon: '☁️',
              title: 'Хмарна інфраструктура та\nDevOps',
              description: 'Побудова та обслуговування надійної хмарної інфраструктури з автоматизованим розгортанням.',
              features: const [
                'Docker та Kubernetes',
                'CI/CD pipeline',
                'Моніторинг та алертинг',
                'SLA 99.9% uptime',
              ],
            ),
            _ServiceCard(
              width: cardWidth,
              icon: '🔗',
              title: 'Системна інтеграція',
              description: 'Інтеграція з державними реєстрами, платіжними системами та зовнішніми сервісами.',
              features: const [
                'Інтеграція з Мін\'юстом',
                'API Prozorro',
                'ДПС та ПФУ',
                'BankID та Дія',
              ],
            ),
            _ServiceCard(
              width: cardWidth,
              icon: '📊',
              title: 'Аналітика та BI',
              description: 'Системи бізнес-аналітики та звітності для прийняття управлінських рішень на основі даних.',
              features: const [
                'Дашборди в реальному часі',
                'Автозвіти Excel/PDF',
                'Data warehouse',
                'Прогнозна аналітика',
              ],
            ),
            _ServiceCard(
              width: cardWidth,
              icon: '🎓',
              title: 'Технічна підтримка та навчання',
              description: 'Цілодобова підтримка систем, навчання держслужбовців та розробка навчальних матеріалів.',
              features: const [
                'L1/L2/L3 підтримка',
                'Helpdesk 24/7',
                'Навчальні програми',
                'Технічна документація',
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final double width;
  final String icon;
  final String title;
  final String description;
  final List<String> features;

  const _ServiceCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF15223A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A657D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: features.map((f) => _CheckItem(text: f)).toList(),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;

  const _CheckItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check,
            size: 18,
            color: Color(0xFF1D5CBB),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5A657D),
                height: 1.4,
              ),
            ),
          )
        ],
      ),
    );
  }
}
