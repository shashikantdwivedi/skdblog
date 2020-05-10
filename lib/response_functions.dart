import 'no_internet.dart';

refreshPage(initializer) {
  initializer.controller.reload();
  initializer.setMenu(false);
}

openSearchPage(initializer) {
  initializer.setSearch(true);
  initializer.controller.evaluateJavascript('''
          document.body.classList.add('has-search');
    ''');
}

closeSearchPage(initializer) {
  initializer.setSearch(false);
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
  checkInternetConnection(initializer);
  if (initializer.pageStatus == 1) {
    if (initializer.currentIndex == 0) {
      closeSearchPage(initializer);
      homePage(initializer);
    } else if (initializer.currentIndex == 1) {
      if (initializer.search) {
        closeSearchPage(initializer);
      } else {
        openSearchPage(initializer);
      }
    } else if (initializer.currentIndex == 2) {
      closeSearchPage(initializer);
      refreshPage(initializer);
    } else if (initializer.currentIndex == 3) {
      closeSearchPage(initializer);
      aboutPage(initializer);
    }
  }
}
