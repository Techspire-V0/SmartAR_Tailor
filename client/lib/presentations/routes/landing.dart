import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartar/data/sources/providers/index.dart';
import 'package:smartar/presentations/widgets/onboarding/init_screens.dart';
import 'package:smartar/presentations/widgets/onboarding/screen.dart';
import 'package:smartar/presentations/widgets/shared/status_overlay.dart';
import 'package:smartar/presentations/widgets/shared/theme/toggle.dart';

class OnboardingScreens extends ConsumerStatefulWidget {
  const OnboardingScreens({super.key});
  @override
  ConsumerState<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends ConsumerState<OnboardingScreens> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return StatusOverlayListener(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/images/logo.png"),
          actions: [ThemeToggle()],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged:
                    (index) =>
                        ref.read(onboardingPageProvider.notifier).state = index,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingScreen(
                    pageController: _pageController,
                    page: onboardingPages[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
