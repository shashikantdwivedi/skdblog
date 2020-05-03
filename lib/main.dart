import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print("#@#@#@##@#@#@##@#@#@##@#@#@#$token#@#@#@##@#@#@##@#@#@##@#@#@#");
    });
  }

  WebViewController _controller;
  int _currentIndex = 0;

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
     if (_currentIndex == 0) {
       homePage();
     } else if (_currentIndex == 1) {
       refreshPage();
     } else if (_currentIndex == 2) {
       aboutPage();
     }
   });
 }

  refreshPage() {
    _controller.reload();
  }

  homePage() {
    _controller.loadUrl('https://shashikantdwivedi.com');
  }

  aboutPage() {
    _controller.loadUrl('https://shashikantdwivedi.com/about-me');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shashikant Dwivedi Blog',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Shashikant Dwivedi Blog',
                  style: TextStyle(fontFamily: 'Circular Std Black')),
              backgroundColor: Colors.black54,
            ),
            bottomNavigationBar:
                BottomNavigationBar(
                  // backgroundColor: Colors.white10,
                  currentIndex: _currentIndex,
                  onTap: onTabTapped,
                  items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home',
                      style: TextStyle(fontFamily: 'Circular Std Black'))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.refresh),
                  title: Text('Refresh',
                      style: TextStyle(fontFamily: 'Circular Std Black'))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  title: Text('About',
                      style: TextStyle(fontFamily: 'Circular Std Black')))
            ]),
            body: WebView(
              initialUrl: 'https://shashikantdwivedi.com',
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}

void main() {
  runApp(MyApp());
}
