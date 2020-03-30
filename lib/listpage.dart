import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/ticketItem.dart';
import 'services/authService.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage> {

  Future _data;
  
  Future getTickets() async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('users').document(uid).collection('tickets').getDocuments(); //creates required collections and documents if they do not already exist

    return qn.documents; //array of docements

  }

  @override
  void initState(){
    super.initState();
    _data = getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _data,
        builder:(_,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text('Loading ...'),
            );
          } else {

            return ListView(
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
                
                SizedBox(
                  height: 15,
                ),

                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){

                    return TicketItem(
                      //color will be set using ticket document field
                      foreColor: Color(0xff2BC8D8),
                      backColor: Color(0xffE5F7F8),
                      plateID: snapshot.data[index].data['plateID'], //"SUR 360",
                      reason: snapshot.data[index].data['reason'], //"Parking in front of fire hydrant",
                      amount: '\$' + snapshot.data[index].data['amount'].toString(), //"\$55"
                      address: snapshot.data[index].data['address'],//"153 Burry Road",
                      date: snapshot.data[index].data['date'],//DateTime.now(),
                    );

                }
                )
                ]
                );

          }
        }
      )      
    );
  }
}