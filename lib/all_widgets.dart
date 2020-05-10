import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'no_internet.dart';
import 'response_functions.dart';

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
    leading: backButton(initializer),
    title: Text('Shashikant Dwivedi Blog',
        style: TextStyle(fontFamily: 'Circular Std Black')),
    backgroundColor: Colors.black,
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
        if (initializer.pageStatus == 1) {
          FlutterShare.share(
            title: initializer.currentTitle,
            text: 'Check out this article',
            linkUrl: initializer.currentUrl,
          );
        }
      },
      child: Icon(Icons.share),
      tooltip: 'Share');
}

Widget loader(initializer) {
  checkInternetConnection(initializer);
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black87,
        strokeWidth: 1,
      ),
    ),
  );
}

Widget backButton(initializer) {
  if (initializer.pageStatus == 1) {
    if (initializer.back) {
      return GestureDetector(
          onTap: () {
            initializer.controller.goBack();
          },
          child: Icon(Icons.arrow_back));
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Widget showMenu(initializer) {
  if (initializer.pageStatus == 1) {
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
  } else {
    return Icon(Icons.menu);
  }
}
