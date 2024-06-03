import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var detector;
  var cameraCount = 0;
  var isCameraInitialized = false.obs;
  var x, y, w, h = 0.0;
  var label = "";



  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      isCameraInitialized(true);
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });

      update();
    } else {
      log("error");
      Get.snackbar("Error", "Permission denied");
    }
  }

  initTFLite() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  objectDetector(CameraImage image) async {
    detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      rotation: 90,
      threshold: 0.4,
    );
    if (detector != null) {
      label=detector.first['label'].toString();
    }

    // log((detector!.first["confidence"] as double).toStringAsFixed(1));
    // log(detector.first['label'].toString());

    // if (detector != null) {
    //   if ((detector['confidence'] * 100).toStringAsFixed(0) > 45) {
    //     label = detector.first['detectedClass'].toString();
    //     h = detector['rect']['h'];
    //     w = detector['rect']['w'];
    //     x = detector['rect']['x'];
    //     y = detector['rect']['y'];
    //   }
    //   update();
    // }
  }
}
