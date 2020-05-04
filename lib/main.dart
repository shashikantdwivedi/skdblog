import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  var brightness = true;
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
    _firebaseMessaging.getToken().then((token) {
      print("$token");
    });
  }

  WebViewController _controller;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        homePage();
        // correctBrightness();
      } else if (_currentIndex == 1) {
        searchPage();
        // correctBrightness();
      } else if (_currentIndex == 2) {
        refreshPage();
        // correctBrightness();
      } else if (_currentIndex == 3) {
        aboutPage();
        // correctBrightness();
      }
    });
  }

  Widget screenBrightness() {
    if (brightness) {
      return Icon(Icons.brightness_3);
    } else {
      return Icon(Icons.brightness_7);
    }
  }

  // adjustBrightness() {
  //   if (brightness) {
  //     _controller.evaluateJavascript('''
  //                           document.documentElement.setAttribute('data-theme', 'dark');
  //                     ''');
  //   } else {
  //     _controller.evaluateJavascript('''
  //                           document.documentElement.setAttribute('data-theme', 'light');
  //                     ''');
  //   }
  //   setState(() {
  //     brightness = !brightness;
  //   });
  // }

  // correctBrightness() {
  //   if (brightness) {
  //     _controller.evaluateJavascript('''
  //             document.documentElement.setAttribute('data-theme', 'light');
  //     ''');
  //     print('Light');
  //   } else {
  //     _controller.evaluateJavascript('''
  //             document.documentElement.setAttribute('data-theme', 'dark');
  //     ''');
  //   print('Dark');
  //   }
  // }

  refreshPage() {
    _controller.reload();
  }

  searchPage() {
    _controller.evaluateJavascript('''
          document.body.classList.add('has-search');
    ''');
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
              // actions: [
              //   GestureDetector(
              //       onTap: () {
              //         adjustBrightness();
              //       },
              //       child: Container(
              //           margin: EdgeInsets.all(15.0),
              //           child: screenBrightness()))
              // ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: onTabTapped,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home',
                          style: TextStyle(fontFamily: 'Circular Std Black'))),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      title: Text('Search',
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
              onPageFinished: (option) {
                _controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                ''');
              },
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}

void main() {
  runApp(MyApp());
}
