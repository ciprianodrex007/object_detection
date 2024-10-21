// ignore_for_file: unused_import, avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  Timer? detectionTimer;
  var x,
      y,
      w,
      h = 0.0;
  var label = "";

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFlite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    Tflite.close();
  }

  initCamera() async {
    if (await Permission.camera
        .request()
        .isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
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
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  initTFlite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/label.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    detectionTimer?.cancel();
    // Start a new timer with a delay
    detectionTimer = Timer(const Duration(milliseconds: 500), () async {
      var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) {
          return e.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        threshold: 0.3,
      );


      if (detector != null) {
        log("Result is $detector");

        var ourDetectedObject = detector.first!;
        print(
            "---------------------------------------------------------------   $ourDetectedObject");

        if (ourDetectedObject['confidence'] * 100 > 25.0) {
          label = ourDetectedObject['label'].toString();
          // h = ourDetectedObject['rect']['h'];
          // w = ourDetectedObject['rect']['w'];
          // x = ourDetectedObject['rect']['x'];
          // y = ourDetectedObject['rect']['y'];
          // print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        } else {
          // Provide default values or fallback logic if 'rect' is not present

        }
        h = 0;
        w = 0;
        x = 0;
        y = 0;
        update();
      }
    });
  }
}