import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'customBrowser.dart';

class LabelImageWidget extends StatefulWidget {
  String image_path;
  var labels;
  LabelImageWidget({required this.image_path, this.labels});
  @override
  State<StatefulWidget> createState() {
    return LabelImageWidgetState();
  }

  // @override
  // LabelImageWidgetState createState() => LabelImageWidgetState();
}

class LabelImageWidgetState extends State<LabelImageWidget> {
  late String image_path;
  var labels;
  ImagePicker imagePicker = ImagePicker();
  late File _file;
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0xFF6305dc),
          title: Text(
            'Results',
            style: TextStyle(fontFamily: 'Gilroy'),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("gifFinal.gif"), fit: BoxFit.cover)),
            // color: Color(0xFF181818),
            child: _buildBody()),
      ),
    );
  }

  Widget _buildImage() {
    _file = File(widget.image_path);
    return SizedBox(
      height: 325.0,
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
                        padding: EdgeInsets.only(bottom: 20),
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
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          _buildImage(),
          _buildList(_currentLabels),
        ],
      ),
    );
  }

  Widget _buildList(List<VisionLabel> labels1) {
    List labels = List.filled(2, []);
    labels[0] = labels1;
    labels[1] = _buildTextForm();
    print(labels[0].length);
    if (labels[0].length == 0) {
      return Text('No results found !',
          style: TextStyle(color: Colors.white, fontSize: 20));
    }
    return Expanded(
      child: Container(
        color: Colors.black,
        // padding: EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          itemCount: labels[0].length + 1,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Color(0xFF212121),
              child: (index < labels[0].length)
                  ? ListTile(
                      leading: Text(
                        "${index + 1}.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Gilroy'),
                      ),
                      title: Text(
                        labels[0][index].label,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Gilroy'),
                      ),
                      subtitle: Text(
                        (100 * labels[0][index].confidence).toStringAsFixed(2) +
                            '% match',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Gilroy'),
                      ),
                      onTap: () async {
                        var url;
                        var newQuery = "";
                        var splitList;
                        if (labels[0][index].label.contains(" ")) {
                          splitList = labels[0][index].label.split(' ');
                          splitList
                              .forEach((element) => newQuery += element + "+");
                          newQuery = newQuery.substring(0, newQuery.length - 1);
                          print(newQuery);
                        } else {
                          newQuery = labels[0][index].label;
                          print("Fail");
                        }
                        print(newQuery);
                        if (SplashPage.isLoggedIn)
                          url = 'https://www.amazon.in/s?k=${newQuery}';
                        else {
                          url =
                              'https://www.amazon.in/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fs%3Fk%3D${newQuery}%2B%2B%26adgrpid%3D61682507911%26ext_vrnc%3Dhi%26hvadid%3D398041351197%26hvdev%3Dc%26hvlocphy%3D9299608%26hvnetw%3Dg%26hvqmt%3Db%26hvrand%3D1229409057575211266%26hvtargid%3Dkwd-314793657586%26hydadcr%3D24565_1971419%26tag%3Dgooginhydr1-21%26ref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=inflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&';
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomBrowser(url, newQuery)));
                      },
                    )
                  : Container(child: labels[1]),
            );
          },
        ),
      ),
    );
  }

  _launchUrl(keyword) async {
    var url;
    if (SplashPage.isLoggedIn)
      url = 'https://www.amazon.in/s?k=${keyword}';
    else {
      url =
          'https://www.amazon.in/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fs%3Fk%3D${keyword}%2B%2B%26adgrpid%3D61682507911%26ext_vrnc%3Dhi%26hvadid%3D398041351197%26hvdev%3Dc%26hvlocphy%3D9299608%26hvnetw%3Dg%26hvqmt%3Db%26hvrand%3D1229409057575211266%26hvtargid%3Dkwd-314793657586%26hydadcr%3D24565_1971419%26tag%3Dgooginhydr1-21%26ref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=inflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&';
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CustomBrowser(url, keyword)));
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

  Widget _buildTextForm() {
    var url = 'https://www.amazon.co.in';
    TextEditingController _queryController = TextEditingController();
    return Column(
      children: [
        TextField(
          controller: _queryController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Type here for additional keywords!",
            hintMaxLines: 1,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        MaterialButton(
            padding: EdgeInsets.only(left: 45, right: 45, top: 20, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(
                width: 3,
                color: Color(0xFF212121),
              ),
            ),
            color: Color(0xFF6305dc),
            child: Text("Amazon Search",
                style: new TextStyle(
                    fontSize: 17.0, color: Colors.white, fontFamily: 'Gilroy')),
            onPressed: () {
              _launchUrl(
                  '${_queryController.text + '+' + labels[0].label.toLowerCase() + '+' + (labels.length > 1 ? labels[1].label.toLowerCase() : '')}');
            }),
        SizedBox(height: 15)
      ],
    );
  }
}
