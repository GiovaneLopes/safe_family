import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  final CameraController controller;
  final Function() switchCameras;
  final Function(XFile) takePicture;
  const CameraPage(
      {super.key,
      required this.controller,
      required this.takePicture,
      required this.switchCameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(controller),
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () async {
                    final picture = await controller.takePicture();
                    takePicture(picture);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  color: Colors.black,
                  iconSize: 35,
                ),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 20,
              child: IconButton(
                onPressed: () => switchCameras(),
                icon: const Icon(Icons.switch_camera_outlined),
                color: Colors.white,
                iconSize: 35,
              ),
            )
          ],
        ),
      ),
    );
  }
}
