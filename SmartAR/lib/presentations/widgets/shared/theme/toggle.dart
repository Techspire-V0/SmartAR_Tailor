import 'package:SmartAR/data/sources/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDark ? Icons.nightlight_round : Icons.wb_sunny,
          color: isDark ? colorScheme.primary : colorScheme.secondary,
          size: 18,
        ),
        Switch.adaptive(
          activeColor: colorScheme.primary,
          inactiveThumbColor: colorScheme.secondary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: isDark,
          onChanged: (_) {
            ref.read(themeProvider.notifier).toggleTheme();
          },
        ),
      ],
    );
  }
}
