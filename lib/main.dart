import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/label_detect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(duration: 5, goToPage: HomePage())));
}

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;
  SplashPage({this.goToPage,  this.duration});

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
                color: Color(0xFF00aff0),
                child:
                    Center(child: Image.asset('assets/icons8_camera_96.png')))),
      ),
    );
  }
}

enum ImageSourceType { gallery, camera }

class HomePage extends StatelessWidget {
  FirebaseVisionLabelDetector labelDetector = FirebaseVisionLabelDetector.instance;
  void _handleURLButtonPress(BuildContext context, var type) {
    final imagePicker = ImagePicker();
    XFile file;
    File useFile;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("                         Image Picker "),
        ),
        body: Container(
          height: 800,
          width: 505,
          color: Colors.white,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    "\n            Pick Image\n           from Gallery              \n",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _handleURLButtonPress(context, ImageSourceType.gallery);
                  },
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    "\n            Pick Image\n           from Camera            \n",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _handleURLButtonPress(context, ImageSourceType.camera);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

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
  XFile image;
  

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseVisionLabelDetector labelDetector = FirebaseVisionLabelDetector.instance;
    List<VisionLabel> _currentLabels = <VisionLabel>[];
    var   sharedPreferences =  SharedPreferences.getInstance();
    var labels;
    String answer;
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "        Image from Camera"
              : "        Image from Gallery")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52,
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
                setState(()  {
                  _image = File(image.path);
               
                 
                });
                
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 100.0,
                        fit: BoxFit.fitWidth
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        width: 200,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                        
                      ),
                      
                      ElevatedButton(onPressed: () async{
                        
                      
                    try{
                    labels =  await labelDetector.detectFromPath(image.path);
                }catch(e){
                  print(e);
                }
                setState(() {
                  _currentLabels = labels;
                
                });
                print('this is label ${labels[0].label}');
                      
                      
                         
                      }, child: Text('Detect')),
                      Text(_currentLabels.toString() ==  null ? _currentLabels[0].toString():'detecting')])
              ),
            ),
          )
        ],
      ),
    );
    

  }
  

 
}
