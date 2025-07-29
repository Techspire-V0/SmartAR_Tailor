import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartar/core/types/auth.dart';
import 'package:smartar/data/sources/providers/index.dart';

class StatusOverlayListener extends ConsumerStatefulWidget {
  final Widget child;
  const StatusOverlayListener({required this.child, super.key});

  @override
  ConsumerState<StatusOverlayListener> createState() =>
      _StatusOverlayListenerState();
}

class _StatusOverlayListenerState extends ConsumerState<StatusOverlayListener> {
  OverlayEntry? _entry;
  Timer? _timer;

  @override
  void dispose() {
    _entry?.remove();
    _timer?.cancel();
    super.dispose();
  }

  void _showOverlay(APIStatus status) {
    final overlay = Overlay.of(context);

    _entry?.remove(); // remove existing
    _timer?.cancel();

    final bgColor = status.success ? Colors.green[100] : Colors.red[100];
    final textColor = status.success ? Colors.green[800] : Colors.red[800];

    _entry = OverlayEntry(
      builder:
          (context) => Positioned(
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        status.message,
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor, size: 15),
                      onPressed: _removeOverlay,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(_entry!);

    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) _removeOverlay();
    });
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
    if (mounted) {
      ref.read(statusMessageProv.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<APIStatus?>(statusMessageProv, (prev, next) {
      if (next != null && mounted) {
        _showOverlay(next);
      }
    });

    return widget.child;
  }
}
