import 'package:flutter/material.dart';
import 'package:trab/screens/home.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              backgroundColor: Color(0xff23272a),
              primarySwatch: Colors.blueGrey,
              accentColor: Color(0xff7289da),
              cardColor: Color(0xff2c2f33),
              brightness: Brightness.dark
            ),
            home: Home(title: 'Flutter Demo Home Page'),
        );
    }
}