import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{

  @override
  _SignInScreenState createState() => new _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x058fff),
                  Color(0x021879)
                ],
                stops: [0,1]
              )
            ),
          )
        ],
      )
    );

  }

}