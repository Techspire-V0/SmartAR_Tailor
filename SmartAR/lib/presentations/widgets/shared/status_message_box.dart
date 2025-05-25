import 'package:SmartAR/data/sources/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class StatusOverlay {
  static OverlayEntry? _overlayEntry;

  static void close(WidgetRef ref) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    ref.read(statusMessageProv.notifier).state = null;
  }

  static void show(BuildContext context, WidgetRef ref) {
    _overlayEntry?.remove();
    final status = ref.watch(statusMessageProv);

    if (status == null) return;

    final bgColor = status.success ? Colors.green[100] : Colors.red[100];
    final textColor = status.success ? Colors.green[800] : Colors.red[800];

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: 40,
          right: 6,
          child: Material(
            elevation: 6,
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 21,
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      status.message,
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  ),
                  IconButton(
                    onPressed: () => close(ref),
                    icon: Icon(AntDesign.close, color: textColor, size: 15),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () => close(ref));
  }
}
