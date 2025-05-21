class OnboardingPage {
  final List<String> images;
  final String title;
  final String subtitle;
  final bool showNext;
  final int id;

  OnboardingPage({
    required this.images,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.showNext,
  });
}

final onboardingPages = [
  OnboardingPage(
    id: 0,
    images: ['assets/images/home_1.png'],
    title: 'Scan to Measure Instantly',
    subtitle: 'Use your phone to scan and generate accurate body measurements.',
    showNext: true,
  ),
  OnboardingPage(
    id: 1,
    images: ['assets/images/home_2.png'],
    title: 'Find Your Perfect Fit',
    subtitle: 'No more guessing sizes. Get clothes that fit right every time.',
    showNext: true,
  ),
  OnboardingPage(
    id: 2,
    images: ['assets/images/home_3_2.png', 'assets/images/home_3_1.png'],
    title: 'Shop or Send to Tailor',
    subtitle: 'Buy ready-made clothes or share your size with your designer.',
    showNext: false,
  ),
];
