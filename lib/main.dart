import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'initializer.dart';
import 'webview_display.dart';

class SkdBlog extends StatefulWidget {
  @override
  _SkdBlog createState() {
    return _SkdBlog();
  }
}

class _SkdBlog extends State<SkdBlog> {
  Widget backButton(bool back) {
    if (back) {
      return GestureDetector(onTap: () {}, child: Icon(Icons.arrow_back));
    } else {
      return null;
    }
  }

  Widget showMenu(initializer) {
    if (initializer.menu) {
      if (initializer.controller != null) {
        initializer.controller.evaluateJavascript('''
          document.body.classList.add('has-menu');
          document.getElementsByClassName('sideNav-wrap')[0].style.marginTop = '-70px';
    ''');
      }
      return Icon(Icons.close);
    } else {
      if (initializer.controller != null) {
        initializer.controller.evaluateJavascript('''
          document.body.classList.remove('has-menu');
    ''');
      }
      return Icon(Icons.menu);
    }
  }

  refreshPage(initializer) {
    print('Pressed refresh button');
    initializer.controller.reload();
    initializer.setMenu(false);
  }

  openSearchPage(initializer) {
    initializer.controller.evaluateJavascript('''
          document.body.classList.add('has-search');
    ''');
  }

  closeSearchPage(initializer) {
    print('I am here');
    initializer.controller.evaluateJavascript('''
          document.body.classList.remove('has-search');
    ''');
  }

  homePage(initializer) {
    initializer.controller.loadUrl('https://shashikantdwivedi.com');
    initializer.setMenu(false);
  }

  aboutPage(initializer) {
    initializer.controller.loadUrl('https://shashikantdwivedi.com/about-me');
    initializer.setMenu(false);
  }

  void onTabTapped(int index, initializer) {
      initializer.setCurrentIndex(index);
      if (initializer.currentIndex == 0) {
        homePage(initializer);
        // correctBrightness();
      } else if (initializer.currentIndex == 1) {
        if (initializer.search) {
          closeSearchPage(initializer);
        } else {
          openSearchPage(initializer);
        }
        initializer.setSearch(!initializer.search);
        // correctBrightness();
      } else if (initializer.currentIndex == 2) {
        refreshPage(initializer);
        // correctBrightness();
      } else if (initializer.currentIndex == 3) {
        aboutPage(initializer);
        // correctBrightness();
      }
    
  }

  BottomNavigationBar bottomNavigationBar(initializer) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: initializer.currentIndex,
        onTap: (index) {
          onTabTapped(index, initializer);
        },
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
        ]);
  }

  AppBar appBar(initializer) {
    return AppBar(
      leading: backButton(initializer.back),
      title: Text('Shashikant Dwivedi Blog',
          style: TextStyle(fontFamily: 'Circular Std Black')),
      backgroundColor: Colors.black54,
      actions: [
        GestureDetector(
            onTap: () {
              initializer.setMenu(!initializer.menu);
            },
            child: Container(
                margin: EdgeInsets.all(15.0), child: showMenu(initializer)))
      ],
    );
  }

  FloatingActionButton shareButton(initializer) {
    return FloatingActionButton(
        onPressed: () {
          FlutterShare.share(
            title: initializer.currentTitle,
            text: 'Check out this article',
            linkUrl: initializer.currentUrl,
          );
        },
        child: Icon(Icons.share),
        tooltip: 'Share');
  }

  @override
  Widget build(BuildContext context) {
    final initializer = Provider.of<Initializer>(context);
    return SafeArea(
        child: Scaffold(
      appBar: appBar(initializer),
      floatingActionButton: shareButton(initializer),
      bottomNavigationBar: bottomNavigationBar(initializer),
      body: WebViewDisplay(),
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
