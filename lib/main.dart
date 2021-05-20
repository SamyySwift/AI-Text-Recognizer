import 'package:flutter/material.dart';
import 'package:swift_ai/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift AI',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      home: MySplash(),
    );
  }
}
