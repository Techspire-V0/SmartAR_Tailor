import 'dart:convert';

import 'package:SmartAR/data/sources/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final Widget redirectChild;
  final bool? isNegativeAuth;

  const AuthGuard({
    required this.child,
    required this.redirectChild,
    this.isNegativeAuth,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (isNegativeAuth!) {
      return auth.isAuth ? redirectChild : child;
    }

    return !auth.isAuth ? redirectChild : child;
  }
}
