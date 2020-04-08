import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/screens/login_screen.dart';
import 'package:ticket_app/homePage.dart';

class AuthService {
 
  
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Future<FirebaseUser> getUser() async {

  //   return await FirebaseAuth.instance.currentUser();

  // }

  signIn(AuthCredential authCreds) async {
    FirebaseAuth.instance.signInWithCredential(authCreds);

    while (await FirebaseAuth.instance.currentUser() == null) {
    // signed in
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid.toString();

    Firestore.instance.collection('users').document(uid).get().then((onValue) async {
    onValue.exists ? print('firebase entry exists') : await Firestore.instance.collection('users').document(uid).setData({});//.collection('tickets').document().setData({});
    });
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}