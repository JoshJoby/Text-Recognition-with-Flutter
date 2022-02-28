import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/label_detect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'textDetect.dart';

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;
  late XFile image;
  late var image_path = null;

  ImageFromGalleryExState(this.type);

  void _showToast(BuildContext context, String image_path) {
    final scaffold = ScaffoldMessenger.of(context);
    String snackText =
        (image_path != null) ? 'Detecting...' : 'Invalid image !';
    scaffold.showSnackBar(
      SnackBar(
        content: Text(snackText),
        action:
            SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    FirebaseVisionLabelDetector labelDetector =
        FirebaseVisionLabelDetector.instance;
    List<VisionLabel> _currentLabels = <VisionLabel>[];
    var sharedPreferences = SharedPreferences.getInstance();
    var labels;
    String answer;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6305dc),
        title: Text(
            type == ImageSourceType.camera
                ? "Image from Camera"
                : "Image from Gallery",
            style: TextStyle(fontFamily: 'Gilroy')),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage("gifFinal.gif"), fit: BoxFit.cover)),
        // color: Color(0xFF181818),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 222,
            ),
            Center(
                child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                image = await imagePicker.pickImage(
                  source: source,
                  imageQuality: 100,
                );
                setState(() {
                  _image = File(image.path);
                  image_path = image.path;
                });
              },
              child: Container(
                  width: widthScreen,
                  height: heightScreen / 2,
                  // decoration: BoxDecoration(
                  //   color: Color(0xFF181818),
                  // ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _image != null
                            ? Container(
                                // decoration: BoxDecoration(
                                // border: Border.all(
                                //     width: 5, color: Color(0xFF212121)),
                                // ),
                                child: Image.file(_image,
                                    width: 300.0,
                                    height: 300.0,
                                    fit: BoxFit.fitWidth),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF6305dc),
                                    border: Border.all(
                                        width: 5, color: Color(0xFF212121)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(300))),
                                width: 300,
                                height: 300,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                        GestureDetector(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              side: BorderSide(
                                width: 3,
                                color: Color(0xFF212121),
                              ),
                            ),
                            color: Color(0xFF6305dc),
                            onPressed: () async {
                              try {
                                labels = await labelDetector
                                    .detectFromPath(image.path);
                              } catch (e) {
                                print(e);
                              }
                              setState(() {
                                _currentLabels = labels;
                              });
                              _showToast(context, image_path);
                              if (image_path != null) {
                                Future.delayed(Duration(milliseconds: 1500),
                                    () async {
                                  // var labels1 =
                                  //     labels + DetailScreen(image_path);
                                  print(
                                      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                  // print(DetailScreen(image_path)
                                  //     .initializeVision());
                                  DetailScreen detailScreen =
                                      new DetailScreen(image_path);
                                  var labels1 =
                                      await detailScreen.initializeVision();
                                  // print(
                                  //     "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
                                  // print(labels1.length);
                                  // for (final i in labels1) print(i);

                                  // print(labels);
                                  // print(labels1);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => LabelImageWidget(
                                            image_path: image_path,
                                            labels: labels,
                                            textLabels: labels1,
                                          )));
                                });
                              }
                            },
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 20, bottom: 20),
                            child: Text(' Scan image ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Gilroy',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                          ),
                        ),
                      ])),
            )),
          ],
        ),
      ),
    );
  }
}
