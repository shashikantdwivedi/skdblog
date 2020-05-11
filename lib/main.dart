import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'initializer.dart';
import 'webview_display.dart';
import 'no_internet.dart';
import 'all_widgets.dart';

class SkdBlog extends StatefulWidget {
  @override
  _SkdBlog createState() {
    return _SkdBlog();
  }
}

class _SkdBlog extends State<SkdBlog> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  WebViewDisplay webViewDisplay;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print("$token");
    });
  }

  @override
  Widget build(BuildContext context) {
    final initializer = Provider.of<Initializer>(context);
    return SafeArea(
        child: Scaffold(
      appBar: appBar(initializer),
      floatingActionButton: shareButton(initializer),
      bottomNavigationBar: bottomNavigationBar(initializer),
      body: FutureBuilder(builder: (context, projectSnap) {
        return initializer.pageStatus == 1
            ? WebViewDisplay()
            : (initializer.pageStatus == 0
                ? loader(initializer)
                : NoInternet());
      }),
    ));
  }
}

void main() {
  runApp(MaterialApp(
    title: 'skdblog',
    home:
        ChangeNotifierProvider(create: (_) => Initializer(), child: SkdBlog()),
  ));
}
