import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:safe_lopes_family/src/resources/images.dart';

class CustomPhotoMarker extends StatelessWidget {
  final XFile picture;
  const CustomPhotoMarker({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: 85,
          width: 85,
          child: Image.asset(
            Images.personLocationPin,
          ),
        ),
        Positioned(
          top: 5,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Image.file(
                  File(
                    picture.path,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
