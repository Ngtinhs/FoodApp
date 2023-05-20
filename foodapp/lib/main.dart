import 'package:flutter/material.dart';
import 'package:foodapp/view/Welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
            labelColor: Color.fromRGBO(59, 185, 52, 1),
            // labelStyle: TextStyle(color: Colors.red[800]),
            // labelColor: Color.fromRGBO(59, 185, 52, 1),
            indicator: UnderlineTabIndicator(
                // color for indicator (underline)
                borderSide: BorderSide(color: Color.fromRGBO(59, 185, 52, 1)))),
        // primaryColor: Colors.blue[800], // outdated and has no effect to Tabbar
        // accentColor: Colors.blue[600] // deprecated,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Welcome(),
    );
  }
}
// primaryColor: Color.fromRGBO(59, 185, 52, 1)
