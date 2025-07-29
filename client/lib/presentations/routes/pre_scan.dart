import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smartar/data/consts.dart';
import 'package:smartar/presentations/routes/scan.dart';
import 'package:smartar/presentations/routes/signin.dart';
import 'package:smartar/presentations/widgets/shared/auth_guard.dart';
import 'package:smartar/presentations/widgets/shared/button.dart';
import 'package:smartar/presentations/widgets/shared/button_nav.dart';
import 'package:smartar/presentations/widgets/shared/status_overlay.dart';
import 'package:smartar/presentations/widgets/shared/theme/toggle.dart';

class PreScanScreen extends ConsumerWidget {
  const PreScanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthGuard(
      redirectChild: SignInPage(),
      isNegativeAuth: false,
      child: StatusOverlayListener(
        child: Scaffold(
          appBar: AppBar(
            leading: Image.asset("assets/images/logo.png"),
            title: Text(
              "Pre-Scan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color:
                    Theme.of(context).colorScheme.secondary, // Uses theme color
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [ThemeToggle()],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Start Measurement Scan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.secondary, // Uses theme color
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 7), // Add spacing
                SizedBox(
                  width: 250,
                  child: Center(
                    child: Text(
                      "Follow the guide to capture your body accurately.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.secondary, // Uses theme color
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20), // Add spacing

                Image.asset(
                  'assets/images/full_pose.png',
                  width: 250,
                  height: 250,
                  color: primaryColor,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 3,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "For best results:",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.secondary, // Uses theme color
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Entypo.light_down, color: primaryColor),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            "Ensure good lighting",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/scan_pose.png',
                          color: primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Ensure full body is visible in the camera view.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/tight_cloth.png',
                          color: primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Wear tight-fitting or athletic clothing",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          MaterialCommunityIcons.rotate_360,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Slowly turn around in place 360° when scanning starts.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          MaterialCommunityIcons.camera,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "The scan will take 10 seconds. Turn at a steady pace — not too fast.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(), // Add spacing
                Button(
                  text: "Start Scan",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNav(pageIndex: 0),
        ),
      ),
    );
  }
}
