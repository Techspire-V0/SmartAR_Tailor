import 'package:SmartAR/data/consts.dart';
import 'package:SmartAR/data/sources/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Switch(
      activeColor: primaryColor,
      value: themeMode == ThemeMode.dark,
      onChanged: (_) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}
