import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

class DetailScreen {
  DetailScreen(this.path);

//   @override
//   DetailScreenState createState() => DetailScreenState(imagePath);
// }

// class DetailScreenState extends State<DetailScreen> {
  final String path;
  Size _imageSize = Size(0, 0);

  String recognizedText = "Loading ...";

  Future<List<String>> initializeVision() async {
    List<String> elements = [];
    var map1 = new Map();
    final File imageFile = File(path);

    if (imageFile != null) {
      _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if ((line.text).length > 2) elements.add(line.text);
      }
    }
    // print("bbbbbbbbbbbbbbbbbbbbbbbbb");
    // for (var i = 0; i < elements.length; i++) {
    //   print(elements[i]);
    // }
    return elements;
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
  }
}
