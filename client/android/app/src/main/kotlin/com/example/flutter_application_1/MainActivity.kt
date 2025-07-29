package com.example.flutter_application_1
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
{
    private val CHANNEL = "com.smartar/camera_intrinsics"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getIntrinsics") {
                try {
                    val cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
                    val cameraId = cameraManager.cameraIdList[0]
                    val characteristics = cameraManager.getCameraCharacteristics(cameraId)

                    val focalLengths = characteristics.get(
                        android.hardware.camera2.CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS
                    ) ?: floatArrayOf(0.0f)

                    val sensorSize = characteristics.get(
                        android.hardware.camera2.CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE
                    )

                    val intrinsics = characteristics.get(
                        android.hardware.camera2.CameraCharacteristics.LENS_INTRINSIC_CALIBRATION
                    ) ?: floatArrayOf(0.0f)

                    result.success(mapOf(
                        "focalLength" to focalLengths[0],
                        "intrinsic" to intrinsics,
                        "sensorWidth" to sensorSize?.width,
                        "sensorHeight" to sensorSize?.height
                    ))
                } catch (e: Exception) {
                    result.error("CAMERA_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}