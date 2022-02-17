import 'package:flutter/material.dart';

class appDesc extends StatelessWidget {
  const appDesc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    var text1 = """App developed by Group 5 

Respective members are :-                                                                                                     

1.   Josh K Joby             ( 1DT20CS063 )                                                                                             
2.   Sai Datha Nikhil     ( 1DT20CS065 )                                                  
3.   Karthik Kulkarni      ( 1DT20CS066 )                                   
4.   Pavan G                   ( 1DT20CS093 )                                         
5.   Prajwal MH              ( 1DT20CS096 )""";

    var text2 = """Features of Image Scanner :-

1.    Via the Phone Camera or Phone Gallery, a photo can be sent by the user to Google Firebase.

2.    The image is processed using Google Firebase Machine Learning, and a set of matching results from the scanning process are displayed to the user.

3.    The user can select an option from the list of results and add to the user's Amazon cart, by logging onto Amazon from within the app itself

4.    The user has the option to buy the product from within the app itself, or the option to save the product in the cart for later purchase.""";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Details',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Gilroy',
                    color: Colors.white,
                    fontWeight: FontWeight.w200)),
            backgroundColor: Color(0xFF6305dc),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
          height: heightScreen,
          width: widthScreen,
          color: Color(0xFF181818),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text('Image Scanner',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Gilroy',
                      color: Colors.white,
                      fontWeight: FontWeight.w200)),
              SizedBox(height: 20),
              Divider(color: Colors.white70),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(text1,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white70),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 12),
                child: Text(text2,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        color: Colors.white,
                        fontWeight: FontWeight.w200)),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
