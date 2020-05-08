import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Initializer with ChangeNotifier {
  bool back = false, menu = false, search = false;
  String currentTitle = '', currentUrl = '';
  int currentIndex = 0;
  WebViewController controller;

  void initializerController(_controller) {
    controller = _controller;
  }

  void setSearch(status) {
    search = status;
    notifyListeners();
  }

  void setCurrentIndex(index) {
    currentIndex = index;
    notifyListeners();
  }

  void setBack(newBack) {
    back = newBack;
    notifyListeners();
  }

  void setMenu(newMenu) {
    menu = newMenu;
    notifyListeners();
  }

  void setCurrentUrl(url) {
    currentUrl = url;
    notifyListeners();
  }

  void setCurrentTitle(title) {
    currentTitle = title;
    notifyListeners();
  }
}