import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


 checkInternetConnection(initializer) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      initializer.setPageStatus(1);
    } else {
     initializer.setPageStatus(2);
    }
  }

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Image.asset(
                    'assets/images/no_internet.png',
                    width: 100.0,
                    height: 100.0,
                  ))),
          Container(padding: EdgeInsets.all(15.0), child: Text('No Internet', style: TextStyle(color: Colors.red),))
        ],
      ),
    ));
  }
}
