import 'package:smartar/core/types/auth.dart';
import 'package:smartar/data/sources/providers/auth_provider.dart';
import 'package:smartar/data/sources/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider();
});

final onboardingPageProvider = StateProvider<int>((ref) => 0);

final statusMessageProv = StateProvider<APIStatus?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
