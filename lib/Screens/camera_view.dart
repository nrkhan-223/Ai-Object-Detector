import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:object_detector/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller2 = Get.put(ScanController());
    Size size = MediaQuery.of(context).size;
    // List<Widget> list = [];
    // list.add(
    //   Positioned(
    //     top: 0.0,
    //     left: 0.0,
    //     width: size.width,
    //     height: size.height - 100,
    //     child: Container(
    //       height: size.height - 100,
    //       child: (!controller2.cameraController.value.isInitialized)
    //           ? Container()
    //           : AspectRatio(
    //               aspectRatio: controller2.cameraController.value.aspectRatio,
    //               child: CameraPreview(controller2.cameraController),
    //             ),
    //     ),
    //   ),
    // );
    // if (controller2.isCameraInitialized.value) {
    //   list.addAll(controller2.displayBoxesAroundRecognizedObjects(size));
    // }
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ScanController>(
            init: ScanController(),
            builder: (controller) {
              return controller.isCameraInitialized.value
                  ? Column(
                      children: [
                        CameraPreview(controller.cameraController),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                color: Colors.white,
                                child: Text(controller.label,style: const TextStyle(color: Colors.black,fontSize: 16),)),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 10),
                        if (controller.isCameraInitialized.value == false)
                          const Text("No Permission"),
                      ],
                    ));
            }),
      ),
    );
  }
}
