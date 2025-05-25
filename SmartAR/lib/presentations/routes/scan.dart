import 'dart:io';

import 'package:SmartAR/data/consts.dart';
import 'package:SmartAR/presentations/widgets/shared/theme/toggle.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import "package:SmartAR/core/services/camera_services.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  final int _startTime = 5;
  final int _recordTime = 10;
  int _progress = 0;
  Timer? _countdownTimer;
  Timer? _recordTimer;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startCountdown();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _startCountdown() {
    setState(() {
      _progress = _startTime;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCameraInitialized) {
        setState(() {
          _progress--;
        });
      }
      if (_progress == 0) {
        _countdownTimer?.cancel();
        _startRecording();
      }
    });
  }

  void _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      // Handle error: camera not initialized
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Camera not initialized')));
      }
      return;
    }

    // --- Camera Intrinsics (Android & iOS) ---
    try {
      // Android: Use platform channel to get CameraCharacteristics
      final intrinsics = await getCameraIntrinsics();
      debugPrint('Camera Intrinsics: $intrinsics');
      // iOS: Use platform channel to get AVCaptureDevice properties
      // This requires platform-specific code. Example method channel usage:
      //
      // static const platform = MethodChannel('camera_intrinsics');
      // final intrinsics = await platform.invokeMethod('getIntrinsics');
      // print('Camera Intrinsics: $intrinsics');
      //
      // For demonstration, print available properties from CameraController:
      final description = _cameraController!.description;
      debugPrint('Camera name: ${description.name}');
      debugPrint('Lens direction: ${description.lensDirection}');
      debugPrint('Sensor orientation: ${description.sensorOrientation}');
      // You can also access _cameraController!.value.previewSize, etc.
    } catch (e) {
      debugPrint('Error getting camera intrinsics: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error getting camera intrinsics')),
        );
      }
      return;
    }
    // --- End Camera Intrinsics ---

    setState(() {
      _isRecording = true;
      _progress = 0;
    });

    await _cameraController!.startVideoRecording();

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        _progress++;
      });
      if (_progress == _recordTime) {
        _recordTimer?.cancel();
        final file = await _cameraController!.stopVideoRecording();

        final basePath = await getApplicationDocumentsDirectory();
        final String dirPath = '${basePath.path}/Videos';
        await Directory(dirPath).create(recursive: true);

        final String newPath =
            '$dirPath/${DateTime.now().millisecondsSinceEpoch}.mp4';

        debugPrint('Video saved to: $newPath');
        await file.saveTo(newPath);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [ThemeToggle()],
      ),
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  Positioned.fill(child: CameraPreview(_cameraController!)),
                  Align(
                    child: Image.asset(
                      "assets/images/full_pose.png",
                      color: primaryColor,
                      width: MediaQuery.of(context).size.width * 0.86,
                      height: MediaQuery.of(context).size.height * 0.83,
                      fit: BoxFit.contain,
                    ),
                  ),

                  if (!_isRecording)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            '$_progress',
                            style: TextStyle(
                              fontSize: 100,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
      bottomSheet:
          _isRecording
              ? LinearProgressIndicator(
                value: _progress / _recordTime,
                backgroundColor: Colors.white24,
                color: primaryColor,
                minHeight: 25,
              )
              : null,
    );
  }
}
