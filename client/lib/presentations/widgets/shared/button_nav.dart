import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smartar/data/consts.dart';
import 'package:smartar/presentations/routes/me.dart';
import 'package:smartar/presentations/routes/pre_scan.dart';
import 'package:smartar/presentations/routes/others.dart';
import 'package:smartar/presentations/routes/shop.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.pageIndex});

  final int pageIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex, // 1 for scan
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      selectedItemColor: primaryColor,
      selectedLabelStyle: TextStyle(fontSize: 0),
      type: BottomNavigationBarType.fixed,
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
              pageBuilder: (_, __, ___) => const MeScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        } else if (index == 3 && pageIndex != index) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const OthersScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Ionicons.camera_outline), label: ''),
        BottomNavigationBarItem(
          icon: Icon(MaterialIcons.shopping_cart),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_3_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Octicons.three_bars), label: ''),
      ],
    );
  }
}
