import 'package:flutter/material.dart';
import 'homePage.dart';
import 'screens/login_screen.dart';
import 'package:ticket_app/services/authService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Futura',
        primarySwatch: Colors.blue,
      ),
      home: AuthService().handleAuth(),
    );
  }
}

