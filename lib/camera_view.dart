import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ar_test/scancontroller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(107),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.yellow[600]!, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                "SGB CAM",
                style: TextStyle(
                  color: Colors.white,
                  // Text color
                  fontSize: 70,
                  // Text size
                  fontWeight: FontWeight.bold,
                  // Text weight
                  fontFamily: 'Roboto',
                  // Font family
                  fontStyle: FontStyle.italic,
                  // Font style
                  letterSpacing: 1.5, // Letter spacing
                ),
              ),
            ),
          ),

        ),
      ),
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
                  children: [
                    CameraPreview(controller.cameraController),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: 50, right: 50, top: 100, bottom: 100),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 4.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          bottom: 50,
                          // Align the container to the bottom of the screen
                          left: 0,
                          // Align the container to the center horizontally
                          right: 0,
                          child: Container(
                            width: 200,
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Text(
                                      controller.label,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'San Francisco'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(
                  child: Text("Loading Perview...."),
                );
        },
      ),
    );
  }
}
