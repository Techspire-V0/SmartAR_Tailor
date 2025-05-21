import 'package:SmartAR/data/sources/providers/index.dart';
import 'package:SmartAR/data/sources/providers/theme_provider.dart';
import 'package:SmartAR/presentations/routes/landing.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  return runApp(const ProviderScope(child: SmartTailorOnboarding()));
}

class SmartTailorOnboarding extends ConsumerWidget {
  const SmartTailorOnboarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const OnboardingScreens(),
    );
  }
}
