import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';

class LabelImageWidget extends StatefulWidget {
  String image_path;
  var labels;
  LabelImageWidget({this.image_path, this.labels});
  @override
  State<StatefulWidget> createState() {
    return LabelImageWidgetState();
  }

  // @override
  // LabelImageWidgetState createState() => LabelImageWidgetState();
}

class LabelImageWidgetState extends State<LabelImageWidget> {
  String image_path;
  var labels;
  ImagePicker imagePicker = ImagePicker();
  File _file;
  List<VisionLabel> _currentLabels = <VisionLabel>[];

  FirebaseVisionLabelDetector detector = FirebaseVisionLabelDetector.instance;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    image_path = widget.image_path;
    labels = widget.labels;
    _currentLabels = labels;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6305dc),
          title: Text('Results'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(color: Color(0xFF181818), child: _buildBody()),
      ),
    );
  }

  Widget _buildImage() {
    _file = File(widget.image_path);
    return SizedBox(
      height: 350.0,
      child: Center(
        child: _file == null
            ? Text('No Image')
            : FutureBuilder<Size>(
                future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
                builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                  if (snapshot.hasData) {
                    // var currentLabel = detector.detectFromPath(image_path);
                    // print(currentLabel);
                    return Container(
                        child: Image.file(_file, fit: BoxFit.fitWidth));
                  } else {
                    return Text('Detecting...');
                  }
                },
              ),
      ),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()))));
    return completer.future;
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildImage(),
          _buildList(_currentLabels),
        ],
      ),
    );
  }

  Widget _buildList(List<VisionLabel> labels) {
    if (labels.length == 0) {
      return Text('No results found !',
          style: TextStyle(color: Colors.white, fontSize: 20));
    }
    return Expanded(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: ListView.builder(
              itemCount: labels.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(
                    "${index + 1}.",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  title: Text(
                    labels[index].label,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  subtitle: Text(
                    (100 * labels[index].confidence).toStringAsFixed(2) +
                        '% match',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onTap: () {
                    _launchUrl(labels[index].label);
                  },
                );
              }),
        ),
      ),
    );
  }

  _launchUrl(keyword) async {
    var _url = 'https://google.com/search?q=${keyword}';
    if (await canLaunch(_url)) {
      await launch(_url,
          forceSafariVC: true, forceWebView: true, enableJavaScript: true);
    } else
      throw 'Could not launch $_url';
  }

  Widget _buildRow(String label, double confidence) {
    return ListTile(
      title: Text(
        "${label}:${confidence}",
      ),
      textColor: Colors.white,
      dense: true,
    );
  }
}
