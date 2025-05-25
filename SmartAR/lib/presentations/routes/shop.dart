import 'package:SmartAR/presentations/widgets/shared/BottomNav.dart';
import 'package:SmartAR/presentations/widgets/shared/theme/toggle.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/images/logo.png"),
        actions: [ThemeToggle()],
      ),
      body: Column(children: []),
      bottomNavigationBar: BottomNav(pageIndex: 1),
    );
  }
}
