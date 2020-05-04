import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_share/flutter_share.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // Initializing firebase messagin class
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  // Declaring some variables
  var menu = false;
  var back = false;
  var currentUrl = '';
  var currentTitle = '';

  // Defining initState
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

  Widget menuToggle() {
    if (menu) {
      return Icon(Icons.close);
    } else {
      return Icon(Icons.menu);
    }
  }

  showMenu() {
    if (menu) {
      _controller.evaluateJavascript('''
          document.body.classList.remove('has-menu');
    ''');
    } else {
      _controller.evaluateJavascript('''
          document.body.classList.add('has-menu');
          document.getElementsByClassName('sideNav-wrap')[0].style.marginTop = '-70px';
    ''');
    }

    setState(() {
      menu = !menu;
    });
  }

  Widget backButton() {
    if (back) {
      return GestureDetector(
          onTap: () {
            _controller.goBack();
          },
          child: Icon(Icons.arrow_back));
    } else {
      return null;
    }
  }

  refreshPage() {
    _controller.reload();
    setState(() {
      menu = false;
    });
  }

  searchPage() {
    _controller.evaluateJavascript('''
          document.body.classList.add('has-search');
    ''');
  }

  homePage() {
    _controller.loadUrl('https://shashikantdwivedi.com');
    setState(() {
      menu = false;
    });
  }

  aboutPage() {
    _controller.loadUrl('https://shashikantdwivedi.com/about-me');
    setState(() {
      menu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shashikant Dwivedi Blog',
        home: Scaffold(
            appBar: AppBar(
              leading: backButton(),
              title: Text('Shashikant Dwivedi Blog',
                  style: TextStyle(fontFamily: 'Circular Std Black')),
              backgroundColor: Colors.black54,
              actions: [
                GestureDetector(
                    onTap: () {
                      showMenu();
                    },
                    child: Container(
                        margin: EdgeInsets.all(15.0), child: menuToggle()))
              ],
            ),
            floatingActionButton:
                FloatingActionButton(onPressed: () {
                  FlutterShare.share(
                        title: currentTitle,
                        text: 'Check out this article',
                        linkUrl: currentUrl,
                  );
                }, child: Icon(Icons.share), tooltip: 'Share'),
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
              onPageStarted: (option) {
                _controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                document.getElementsByClassName('share-sticky')[0].style.display='none';
                ''');
                setState(() {
                  menu = false;
                });
                _controller.currentUrl().then((value) {
                  _controller.getTitle().then((title) {
                    currentUrl = value;
                    currentTitle = title;
                  });
                  if ('shashikantdwivedi.com' != value.split('/')[2]) {
                    _controller.canGoBack().then((value) {
                      if (value) {
                        _controller.goBack();
                      } else {
                        homePage();
                      }
                    });
                  } else {
                    _controller.canGoBack().then((value) {
                      if (value) {
                        _controller.currentUrl().then((value) {
                          if (value == 'https://shashikantdwivedi.com/') {
                            setState(() {
                              back = false;
                            });
                          } else {
                            setState(() {
                              back = true;
                            });
                          }
                        });
                      } else {
                        setState(() {
                          back = false;
                        });
                      }
                    });
                  }
                });
              },
              onPageFinished: (option) {
                _controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                document.getElementsByClassName('share-sticky')[0].style.display='none';
                ''');
              },
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}

void main() {
  runApp(MyApp());
}
