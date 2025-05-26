import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smartar/presentations/routes/pre_scan.dart';
import 'package:smartar/presentations/routes/settings.dart';
import 'package:smartar/presentations/routes/shop.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.pageIndex});

  final int pageIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex, // 1 for scan
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      onTap: (index) {
        if (index == 0 && pageIndex != index) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const PreScanScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        } else if (index == 1 && pageIndex != index) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const ShopScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        } else if (index == 2 && pageIndex != index) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SeetingsScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.camera_outline),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(MaterialIcons.shopping_cart),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
