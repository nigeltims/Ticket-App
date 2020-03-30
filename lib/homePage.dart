
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'models/ticketItem.dart';
import 'screens/login_screen.dart';
import 'services/authService.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    String uid;


  @override
  void initState(){
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val){
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e){
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
    shape: CircleBorder(side: BorderSide(color: Color(0xff2BC8D8), width: 2.0)),
    onPressed: () { },
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
          icon: Icon(Icons.business),
          title: Text('Business'),
        ),
      ],
      selectedItemColor: Color(0xff2BC8D8),

    ),
    ),
    body: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
          SizedBox(
          width: 20,
          ),
            Text("Tickets",
            style: TextStyle(
              color: Color(0xff241A3C),
              // fontFamily: 'FuturaBold',
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
            ),
          SizedBox(
          width: 180,
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: (){
                FirebaseAuth.instance.signOut();
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => AuthService().handleAuth()));
          })
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
        TicketItem(
          foreColor: Color(0xff2BC8D8),
          backColor: Color(0xffE5F7F8),
          plateID: "SUR 360",
          reason: "Parking in front of fire hydrant",
          amount: "\$55", 
          address: "153 Burry Road",
          date: DateTime.now(),
        ),
            SizedBox(
              height: 15,
            ),
        TicketItem(
          foreColor: Color(0xffFF6E6E),
          backColor: Color(0xffFFF1F1),
          plateID: "SUR 360",
          reason: "Parking in front of fire hydrant",
          amount: "\$55", 
          address: "153 Burry Road",
          date: DateTime.now(),
        ),
            SizedBox(
              height: 15,
            ),
        TicketItem(
          foreColor: Color(0xff2BC8D8),
          backColor: Color(0xffE5F7F8),
          plateID: "SUR 360",
          reason: "Parking in front of fire hydrant",
          amount: "\$55", 
          address: "153 Burry Road",
          date: DateTime.now(),
        ),
            SizedBox(
              height: 15,
            ),
        TicketItem(
          foreColor: Color(0xffFF6E6E),
          backColor: Color(0xffFFF1F1),
          plateID: "SUR 360",
          reason: "Parking in front of fire hydrant",
          amount: "\$55", 
          address: "153 Burry Road",
          date: DateTime.now(),
        ),

            SizedBox(
              height: 35,
            ),
          ],
        )
      ],

    ),
    

        
    );
  }
}