import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }

//   runApp(new MyApp());
// }

class CustomBrowser extends StatefulWidget {
  String url;
  String query;
  CustomBrowser(this.url, this.query);
  @override
  _MyAppState createState() => new _MyAppState(url, query);
}

class _MyAppState extends State<CustomBrowser> {
  final GlobalKey webViewKey = GlobalKey();
  String url1;
  String query;
  _MyAppState(this.url1, this.query);
  // String urlLogin =
  //     'https://www.amazon.in/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fs%3Fk%3D' + query + '%2B%2B%26adgrpid%3D61682507911%26ext_vrnc%3Dhi%26hvadid%3D398041351197%26hvdev%3Dc%26hvlocphy%3D9299608%26hvnetw%3Dg%26hvqmt%3Db%26hvrand%3D1229409057575211266%26hvtargid%3Dkwd-314793657586%26hydadcr%3D24565_1971419%26tag%3Dgooginhydr1-21%26ref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=inflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&';
  // String urlResult = 'https://www.amazon.in/s?k=Mobile20%phone';
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          print(await webViewController?.getUrl());
          print("Old url : " + url1);
          // print("New url :  ${newUrl1}");
          webViewController?.reload();
        } else if (Platform.isIOS) {
          // print(webViewController?.getUrl());
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String urlLogin =
        'https://www.amazon.in/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fs%3Fk%3D' +
            query +
            '%2B%2B%26adgrpid%3D61682507911%26ext_vrnc%3Dhi%26hvadid%3D398041351197%26hvdev%3Dc%26hvlocphy%3D9299608%26hvnetw%3Dg%26hvqmt%3Db%26hvrand%3D1229409057575211266%26hvtargid%3Dkwd-314793657586%26hydadcr%3D24565_1971419%26tag%3Dgooginhydr1-21%26ref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=inflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&';
    String urlResult = 'https://www.amazon.in/s?k=' + query;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
              child: Column(children: <Widget>[
        // TextField(
        //   decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
        //   controller: urlController,
        //   keyboardType: TextInputType.url,
        //   onSubmitted: (value) {
        //     var url = Uri.parse(value);
        //     if (url.scheme.isEmpty) {
        //       url = Uri.parse("https://www.google.com/search?q=" + value);
        //     }
        //     webViewController?.loadUrl(urlRequest: URLRequest(url: url));
        //   },
        // ),
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse(url1)),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },

                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    var splitList;
                    print(query);
                    var newQuery = "";
                    if (query.contains("+")) {
                      splitList = query.split('+');
                      print(splitList);
                      splitList
                          .forEach((element) => newQuery += element + "%20");
                      newQuery = newQuery.substring(0, newQuery.length - 3);
                      print(newQuery);
                    } else {
                      newQuery = query;
                      print("Fail");
                    }
                    if (url1 == urlLogin) {
                      if ((urlResult.length - query.length) ==
                          (this.url).indexOf(newQuery)) {
                        SplashPage.isLoggedIn = true;
                        print("Success");
                      } else {
                        print(urlResult.length - query.length);
                        print((this.url).indexOf(newQuery));
                        print(this.url);
                        print("Fail2");
                      }
                    } else
                      print("Fail1");

                    // print(url1);
                    // print(urlController.text);
                  });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    // print(urlController.text);
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = this.url;
                    // print(urlController.text);
                  });
                },

                onCloseWindow: (controller) {
                  setState(() {
                    if ((this.url) == url1) SplashPage.isLoggedIn = false;
                  });
                },

                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    // print(urlController.text);
                  });
                },
                // onConsoleMessage: (controller, consoleMessage) {
                //   print(consoleMessage);
                // },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container(),
            ],
          ),
        ),
        Container(
          color: Color(0xFF181818),
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Color(0xFF6305dc),
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              MaterialButton(
                color: Color(0xFF6305dc),
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              MaterialButton(
                color: Color(0xFF6305dc),
                child: Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
              MaterialButton(
                color: Color(0xFF6305dc),
                child: Icon(Icons.exit_to_app_sharp),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ]))),
    );
  }
}
