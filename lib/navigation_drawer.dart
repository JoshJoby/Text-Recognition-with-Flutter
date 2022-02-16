import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'customBrowser.dart';
import 'main.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF212121),
        child: Column(
          children: <Widget>[
            Container(
              height: 90,
              child: DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ),
            Divider(color: Colors.white70),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Gilroy')),
              onTap: () => {Navigator.of(context).pop()},
            ),
            Divider(color: Colors.white70),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.white),
              title: Text('Cart',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Gilroy')),
              onTap: () {
                if (SplashPage.isLoggedIn) {
                  var url =
                      'https://www.amazon.in/gp/cart/view.html?ref_=nav_cart';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomBrowser(url, ' ')));
                } else {
                  requestSignIn(context);
                }
              },
            ),
            Divider(color: Colors.white70),
            ListTile(
              leading: Icon(Icons.info_outline_rounded, color: Colors.white),
              title: Text('Details',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Gilroy')),
              onTap: () => {Navigator.of(context).pop()},
            ),
            Divider(color: Colors.white70),
            Spacer(),
            Divider(color: Colors.white70),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Gilroy')),
              onTap: () => onWillPop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future onWillPop(context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Color(0xFF6305dc),
        title: new Text('Confirm Exit?',
            style: new TextStyle(
                color: Colors.white, fontSize: 22.0, fontFamily: 'Gilroy')),
        content: new Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: 'Gilroy'),
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                (SplashPage.isLoggedIn)
                    ? new MaterialButton(
                        color: Color(0xFF212121),
                        onPressed: () {
                          SplashPage.isLoggedIn = false;
                          String url =
                              'https://www.amazon.in/gp/flex/sign-out.html?path=%2Fgp%2Fyourstore%2Fhome&signIn=1&useRedirectOnSuccess=1&action=sign-out&ref_=nav_AccountFlyout_signout';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomBrowser(url, ' ')));
                        },
                        child: new Text('Logout from Amazon',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Gilroy')),
                      )
                    : Divider(),
                new MaterialButton(
                  color: Color(0xFF212121),
                  onPressed: () {
                    // this line exits the app.
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: new Text(
                      (SplashPage.isLoggedIn) ? 'Exit anyway' : 'Yes',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Gilroy')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future requestSignIn(context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Color(0xFF6305dc),
        content: new Text(
          'To view your cart, you must sign into your Amazon account',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: 'Gilroy'),
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                new MaterialButton(
                  color: Color(0xFF212121),
                  onPressed: () {
                    SplashPage.isLoggedIn = true;
                    String url =
                        'https://www.amazon.in/ap/signin/ref=cart_empty_sign_in?openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fgp%2Fcart%2Fview.html%3Fapp-nav-type%3Dnone%26dc%3Ddf&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=inflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomBrowser(url, ' ')));
                  },
                  child: new Text('Log into Amazon',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Gilroy')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
