import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartar/presentations/routes/signin.dart';
import 'package:smartar/presentations/widgets/shared/auth_guard.dart';
import 'package:smartar/presentations/widgets/shared/button_nav.dart';
import 'package:smartar/presentations/widgets/shared/status_overlay.dart';
import 'package:smartar/presentations/widgets/shared/theme/toggle.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthGuard(
      redirectChild: SignInPage(),
      isNegativeAuth: false,
      child: StatusOverlayListener(
        child: Scaffold(
          appBar: AppBar(
            leading: Image.asset("assets/images/logo.png"),
            actions: [ThemeToggle()],
          ),
          body: Column(children: []),
          bottomNavigationBar: BottomNav(pageIndex: 2),
        ),
      ),
    );
  }
}
