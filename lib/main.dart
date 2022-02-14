import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/label_detect.dart';
import 'package:flutter_application_1/select_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(duration: 4, goToPage: HomePage())));
}

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;
  SplashPage({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            body: Container(
                color: Color(0xFF181818),
                child:
                    Center(child: Image.asset('assets/icons8_camera_96.png')))),
      ),
    );
  }
}

enum ImageSourceType { gallery, camera }

class HomePage extends StatelessWidget {
  FirebaseVisionLabelDetector labelDetector =
      FirebaseVisionLabelDetector.instance;
  void _handleURLButtonPress(BuildContext context, var type) {
    final imagePicker = ImagePicker();
    XFile file;
    File useFile;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color(0xFF505050),
          width: 1.0,
        )),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker ", style: TextStyle(fontFamily: 'Gilroy')),
          backgroundColor: Color(0xFF6305dc),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("gifFinal.gif"), fit: BoxFit.cover)),
          height: heightScreen,
          width: widthScreen,
          // color: Color(0xFF181818),
          child: Padding(
            padding: EdgeInsets.only(
                top: 0, left: widthScreen / 50, right: widthScreen / 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: Color(0xFF6305dc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          80.0), // CHANGE BORDER RADIUS HERE
                      side: BorderSide(width: 5, color: Color(0xFF212121)),
                    ),
                    padding: EdgeInsets.only(
                        left: widthScreen / 8,
                        right: widthScreen / 8,
                        top: heightScreen / 8,
                        bottom: heightScreen / 8),
                    child: Text(
                      "Pick Image\nfrom Gallery",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          fontSize: 21),
                    ),
                    onPressed: () {
                      _handleURLButtonPress(context, ImageSourceType.gallery);
                    },
                  ),
                  Container(
                    child: SizedBox(width: widthScreen / 2, height: 25),
                    decoration: myBoxDecoration(),
                  ),
                  Container(
                    child: SizedBox(width: 50, height: 25),
                  ),
                  MaterialButton(
                    color: Color(0xFF6305dc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          80.0), // CHANGE BORDER RADIUS HERE
                      side: BorderSide(
                        width: 5,
                        color: Color(0xFF212121),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        left: widthScreen / 8,
                        right: widthScreen / 8,
                        top: heightScreen / 8,
                        bottom: heightScreen / 8),
                    child: Text(
                      "Pick Image\nfrom Camera",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          fontSize: 20.75),
                    ),
                    onPressed: () {
                      _handleURLButtonPress(context, ImageSourceType.camera);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
