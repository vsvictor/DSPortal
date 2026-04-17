class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String services = '/services';
  static const String projects = '/projects';
  static const String news = '/news';
  static const String vacancies = '/vacancies';
  static const String appeals = '/appeals';
  static const String contacts = '/contacts';
  static const String login = '/login';
  static const String register = '/register';
  static const String cabinet = '/cabinet';
}

class PublicSection {
  const PublicSection({required this.title, required this.route});

  final String title;
  final String route;
}

const List<PublicSection> publicSections = <PublicSection>[
  PublicSection(title: 'Про нас', route: AppRoutes.about),
  PublicSection(title: 'Послуги', route: AppRoutes.services),
  PublicSection(title: 'Проекти', route: AppRoutes.projects),
  PublicSection(title: 'Новини', route: AppRoutes.news),
  PublicSection(title: 'Вакансії', route: AppRoutes.vacancies),
  PublicSection(title: 'Звернення', route: AppRoutes.appeals),
  PublicSection(title: 'Контакти', route: AppRoutes.contacts),
];

