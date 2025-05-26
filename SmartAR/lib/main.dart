import 'package:smartar/data/sources/providers/index.dart';
import 'package:smartar/data/sources/providers/theme_provider.dart';
import 'package:smartar/presentations/routes/landing.dart';
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

    ref.read(authProvider.notifier).tryAuth(ref);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: OnboardingScreens(),
    );
  }
}
// #23AGggf#