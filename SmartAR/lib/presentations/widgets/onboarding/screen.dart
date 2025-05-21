import "package:SmartAR/data/consts.dart";
import "package:SmartAR/presentations/widgets/onboarding/init_screens.dart";
import "package:SmartAR/presentations/widgets/shared/button.dart";
import "package:flutter/material.dart";
import "package:flutter_vector_icons/flutter_vector_icons.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.page,
    required this.pageController,
  });

  final PageController pageController;
  final OnboardingPage page;
  final Color darkMode = Colors.black;
  final Color whiteMode = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 460,
            child: Stack(
              clipBehavior: Clip.none,
              children:
                  page.images.map((image) {
                    final isMultipleImages = page.images.length > 1;
                    final reverseIndex =
                        page.images.length - 1 - page.images.indexOf(image);
                    final isEvenIndex = ((page.images.indexOf(image)) % 2 == 0);

                    return Positioned(
                      top: reverseIndex * 200,
                      left: isEvenIndex && !isMultipleImages ? 1 : null,
                      right: isEvenIndex ? 0 : null,
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                        height: page.id == 2 ? null : 460,
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: primaryColor,
            ),
          ),

          // Stacked Images
          const SizedBox(height: 5), // Add spacing
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              color:
                  Theme.of(context).colorScheme.secondary, // Uses theme color
              fontWeight: FontWeight.w900,
            ),
          ),

          // Slogan
          const SizedBox(height: 5), // Add spacing
          SizedBox(
            width: 280,
            child: Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),

          const SizedBox(height: 30),

          (page.showNext)
              ? // Next Button
              Column(
                children: [
                  Button(
                    text: "Next",
                    isOutline: true,
                    color: Theme.of(context).primaryColor,
                    bgColor: Theme.of(context).colorScheme.surface,
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              )
              : Column(
                children: [
                  Button(
                    icon: Icon(
                      FontAwesome5Brands.google,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    text: "Sign In with Google",
                    bgColor: Theme.of(context).colorScheme.surface,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      // Navigate to the next screen
                    },
                  ),
                  const SizedBox(height: 10),
                  Button(
                    text: "Create an account",
                    isOutline: true,
                    color: primaryColor,
                    onPressed: () {
                      // Navigate to the next screen
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(onPressed: () {}, child: const Text("Login")),
                    ],
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
