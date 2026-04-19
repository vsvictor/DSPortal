import 'package:dsportal/app/routes.dart';
import 'package:dsportal/shared/portal_scaffold.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalScaffold(
      title: 'Проекти',
      showTitle: false,
      currentRoute: AppRoutes.projects,
      body: _ProjectsContent(),
    );
  }
}

class _ProjectsContent extends StatelessWidget {
  const _ProjectsContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'ПРОЄКТИ',
              style: TextStyle(
                color: Color(0xFF4338CA),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ключові реалізації',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Відібрані проєкти, що демонструють наш досвід у цифровізації\nдержавного управління',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1000) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 650) {
                crossAxisCount = 2;
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.85,
                children: const [
                  ProjectCard(
                    headerColor: Color(0xFF2563EB),
                    iconStr: '📋',
                    startDate: '01.03.2023',
                    category: 'ERP система',
                    title: 'Єдина інформаційна система\nМінекономіки',
                    description:
                        'Комплексна ERP-система для автоматизації процесів Міністерства економіки. Охоплює документообіг, планування, звітність та аналітику.',
                    tags: ['JAVA', 'VUE.JS', 'POSTGRESQL', 'KUBERNETES'],
                  ),
                  ProjectCard(
                    headerColor: Color(0xFF10B981),
                    iconStr: '📊',
                    startDate: '15.06.2022',
                    category: 'Аналітика',
                    title: 'Система моніторингу\nдержзакупівель',
                    description:
                        'Аналітична платформа для моніторингу та аналізу державних закупівель з інтеграцією Prozorro. Забезпечує прозорість витрат.',
                    tags: ['PYTHON', 'REACT', 'ELASTICSEARCH', 'GRAFANA'],
                  ),
                  ProjectCard(
                    headerColor: Color(0xFF8B5CF6),
                    iconStr: '📦',
                    startDate: '01.02.2022',
                    category: 'Документообіг',
                    title: 'Електронний документообіг',
                    description:
                        'Система електронного документообігу з КЕП-підписанням, маршрутизацією документів та інтеграцією з Мін\'юстом.',
                    tags: ['SPRING BOOT', 'КЕП', 'REST API', 'ORACLE'],
                  ),
                  ProjectCard(
                    headerColor: Color(0xFFD97706),
                    iconStr: '📈',
                    startDate: '10.09.2021',
                    category: 'BI',
                    title: 'Платформа бізнес-аналітики',
                    description:
                        'BI-платформа з інтерактивними дашбордами, автоматичними звітами та прогнозною аналітикою для керівництва Мінекономіки.',
                    tags: ['APACHE SUPERSET', 'DBT', 'AIRFLOW', 'CLICKHOUSE'],
                  ),
                  ProjectCard(
                    headerColor: Color(0xFFDB2777),
                    iconStr: '🔐',
                    startDate: '01.06.2020',
                    category: 'Безпека',
                    title: 'Захищений периметр держсистем',
                    description:
                        'Комплексна система кібербезпеки з SIEM, IDS/IPS, двофакторною автентифікацією та моніторингом загроз.',
                    tags: ['SIEM', 'IDS', '2FA', 'ZERO TRUST'],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Color headerColor;
  final String iconStr;
  final String startDate;
  final String category;
  final String title;
  final String description;
  final List<String> tags;

  const ProjectCard({
    super.key,
    required this.headerColor,
    required this.iconStr,
    required this.startDate,
    required this.category,
    required this.title,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: headerColor,
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    iconStr,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'ДІЄ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Старт: $startDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
