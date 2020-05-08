import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'initializer.dart';

class WebViewDisplay extends StatefulWidget {
  // WebViewDisplay(this.index);
  // final index;
  @override
  _WebViewDisplay createState() {
    return _WebViewDisplay();
  }
}

class _WebViewDisplay extends State<WebViewDisplay> {
  // _WebViewDisplay(this.index);
  // final index;

  // @override
  // void initState() {
  //   refreshPage(initializer) {
  //     initializer.controller.reload();
  //     initializer.setMenu(false);
  //   }

  //   searchPage(initializer) {
  //     initializer.controller.evaluateJavascript('''
  //         document.body.classList.add('has-search');
  //   ''');
  //   }

  //   homePage(initializer) {
  //     initializer.controller.loadUrl('https://shashikantdwivedi.com');
  //     initializer.setMenu(false);
  //   }

  //   aboutPage(initializer) {
  //     initializer.controller.loadUrl('https://shashikantdwivedi.com/about-me');
  //     initializer.setMenu(false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final initializer = Provider.of<Initializer>(context);
    return WebView(
      initialUrl: 'https://shashikantdwivedi.com',
      onWebViewCreated: (WebViewController webViewController) {
        initializer.initializerController(webViewController);
      },
      onPageStarted: (option) {
        initializer.controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                document.getElementsByClassName('share-sticky')[0].style.display='none';
                ''');
        initializer.setMenu(false);
        initializer.controller.currentUrl().then((value) {
          initializer.controller.getTitle().then((title) {
            initializer.setCurrentUrl(value);
            initializer.setCurrentTitle(title);
          });
          if ('shashikantdwivedi.com' != value.split('/')[2]) {
            initializer.controller.canGoBack().then((value) {
              if (value) {
                initializer.controller.goBack();
              } else {
                // homePage();
              }
            });
          } else {
            initializer.controller.canGoBack().then((value) {
              if (value) {
                initializer.controller.currentUrl().then((value) {
                  if (value == 'https://shashikantdwivedi.com/') {
                    initializer.setBack(false);
                  } else {
                    initializer.setBack(false);
                  }
                });
              } else {
                initializer.setBack(false);
              }
            });
          }
        });
      },
      onPageFinished: (option) {
        initializer.controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                document.getElementsByClassName('share-sticky')[0].style.display='none';
                ''');
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
