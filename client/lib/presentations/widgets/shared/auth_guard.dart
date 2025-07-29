import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartar/data/sources/providers/index.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final Widget redirectChild;
  final bool isNegativeAuth;

  const AuthGuard({
    required this.child,
    required this.redirectChild,
    required this.isNegativeAuth,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final shouldRedirect = isNegativeAuth ? auth.isAuth : !auth.isAuth;

    if (shouldRedirect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => redirectChild));
      });
    }

    return child;
  }
}
