import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'form.dart';
import 'listpage.dart';
import 'models/ticketItem.dart';
import 'screens/login_screen.dart';
import 'services/authService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid, ocrLine;
  String ticketNumber, licensePlate, fine, codeNo, location;
  DateTime date;
  File pickedImage;
  bool _loading = false;
  int _currentIndex = 0;
  final List<Widget> _children = [
    ListPage(),
    NotificationPage(),
  ];

  RegExp ticketCheck = RegExp(r'^..\d{6}');
  RegExp plateCheck = RegExp(r'^[A-Z]{4}\d{3}');
  RegExp priceCheck = RegExp(r'[$]\s?\d+[,|\.]?\s?\d{2}');
  RegExp reasonCheck = RegExp(r'[C|c][o|O]de\s?N[o|O][\.|,]?\s?\d{1,6}');
  RegExp dateCheck = RegExp(r'20\d\d[\.|,|\s]\d\d[\.|,|\s]\d\d');
  RegExp locationCheck = RegExp(r'^NR\s');

//Get Image From Camera

  Future pickImage() async {
    _loading = true;
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempStore;
    });

    readText();
  }

//Use Firebase ML-kit for OCR and parse out ticket #, license plate, fine, and reason (code #)

  Future readText() async {
    if (pickedImage == null) {
      _loading = false;
      return;
    }
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        ocrLine = line.text;

        if (ticketCheck.hasMatch(ocrLine)) {
          print('Ticket Number is $ocrLine');
          ticketNumber = ocrLine;
        }

        if (plateCheck.hasMatch(ocrLine)) {
          print('License Plate is $ocrLine');
          licensePlate = ocrLine;
        }

        if (reasonCheck.hasMatch(ocrLine)) {
          print('Code # is ${RegExp(r'\d{1,6}').firstMatch(ocrLine).group(0)}');
          codeNo = RegExp(r'\d{1,6}').firstMatch(ocrLine).group(0);
        }

        if (priceCheck.hasMatch(ocrLine)) {
          fine = priceCheck
              .firstMatch(ocrLine)
              .group(0)
              .replaceAllMapped(RegExp(r'[\s|\$|,]'), (Match m) => '');
          if (fine[fine.length - 3] != '.') {
            fine =
                '${fine.substring(1, fine.length - 2)}.${fine.substring(fine.length - 2)}';
          }
          print('Fine is $fine');
        }
        if (dateCheck.hasMatch(ocrLine)) {
          date = DateTime.parse(dateCheck
              .firstMatch(ocrLine)
              .group(0)
              .replaceAllMapped(RegExp(r'\.'), (Match m) => '-'));
          print('date is $date');
        }
        if (locationCheck.hasMatch(ocrLine)) {
          location = ocrLine;
          print('location is $location');
        }

        print(ocrLine);
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new FormPage(
                  ticketNumber: ticketNumber,
                  fine: fine,
                  licensePlate: licensePlate,
                  codeNo: codeNo,
                  infractionDate: date,
                  infractionAddress: location,
                  newticket: true,
                )));
    _loading = false;
  }

  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffffffff),
          foregroundColor: Color(0xff2BC8D8),
          shape: CircleBorder(
              side: BorderSide(color: Color(0xff2BC8D8), width: 2.0)),
          onPressed: pickImage, //() { },
          tooltip: 'Increment',
          child: Icon(Icons.add),
          elevation: 2.0,
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          shape: CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text('Notifications'),
              ),
            ],
            selectedItemColor: Color(0xff2BC8D8),
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
          ),
        ),
        body: Center(
          child:
              _loading ? CircularProgressIndicator() : _children[_currentIndex],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
