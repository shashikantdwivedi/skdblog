import 'package:Shashikant_Dwivedi_Blog/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'initializer.dart';
import 'response_functions.dart';

bool verifyDomain(domain) {
  var baseDomain = domain.split('/')[2];
  var supportedDomain = {'twitter.com', 'github.com', 'linkedin.com'};
  if (baseDomain == 'shashikantdwivedi.com') {
    return true;
  } else if (supportedDomain.contains(baseDomain)) {
    return true;
  } else {
    return false;
  }
}

class WebViewDisplay extends StatefulWidget {
  @override
  _WebViewDisplay createState() {
    return _WebViewDisplay();
  }
}

class _WebViewDisplay extends State<WebViewDisplay> {
  @override
  Widget build(BuildContext context) {
    final initializer = Provider.of<Initializer>(context);
    return WebView(
      initialUrl: 'https://shashikantdwivedi.com',
      onWebViewCreated: (WebViewController webViewController) {
        initializer.initializerController(webViewController);
      },
      onWebResourceError: (error) {
        print('${error.description}');
        checkInternetConnection(initializer);
      },
      onPageStarted: (option) {
        initializer.setMenu(false);
        if (initializer.pageStatus == 1) {
          initializer.controller.currentUrl().then((value) {
            initializer.controller.getTitle().then((title) {
              initializer.setCurrentUrl(value);
              initializer.setCurrentTitle(title);
            });
            if (verifyDomain(value)) {
              initializer.controller.canGoBack().then((value) {
                if (value) {
                  initializer.setBack(true);
                } else {
                  initializer.setBack(false);
                }
              });
            } else {
              homePage(initializer);
            }
          });
        }
      },
      onPageFinished: (option) {
        if (initializer.pageStatus == 1) {
          initializer.controller.evaluateJavascript('''
                document.getElementsByClassName('header')[0].style.display='none';
                document.getElementsByClassName('share-sticky')[0].style.display='none';
                ''');
        }
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
