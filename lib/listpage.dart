import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/notification.dart';
import 'form.dart';
import 'models/ticketItem.dart';
import 'services/authService.dart';
import 'utilities/column_builder.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;
  String userFirstName;
  String userLastName;
  DateTime userBirthDate;
  String uid;

  Future getTickets() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid.toString();

    var firestore = Firestore.instance;

    //print('uid:'+uid);
    DocumentReference userSnapshot =
        firestore.collection('users').document(uid);

    userSnapshot.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        userFirstName = datasnapshot.data['first name'];
        userLastName = datasnapshot.data['last name'];
        userBirthDate = datasnapshot.data['birthdate'].toDate();
      } else {
        userFirstName = '';
        userLastName = '';
        userBirthDate = DateTime.now();
      }
    });

    QuerySnapshot qn = await firestore
        .collection('users')
        .document(uid)
        .collection('tickets')
        .getDocuments(); //creates required collections and documents if they do not already exist

    return qn.documents; //array of docements
  }

  @override
  void initState() {
    super.initState();
    _data = getTickets();
  }

  void refresh(){
    setState(() {
      _data = getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                          Text(
                            "Tickets",
                            style: TextStyle(
                                color: Color(0xff241A3C),
                                // fontFamily: 'FuturaBold',
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FormPage()));
                              })
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ColumnBuilder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Column(children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              TicketItem(
                                //color will be set using ticket document field
                                listPageRefresh: refresh,
                                status: snapshot.data[index].data['status'] == null ? '' : snapshot.data[index].data['status'],
                                firstName: userFirstName,
                                lastName: userLastName,
                                birthDate: userBirthDate,
                                documentID: snapshot.data[index].documentID,
                                infractionDate: snapshot
                                    .data[index].data['infractionDate']
                                    .toDate(),
                                infractionAddress: snapshot
                                    .data[index].data['infractionAddress'],
                                ticketNumber:
                                    snapshot.data[index].data['ticket_id'],
                                code: snapshot.data[index].data['code'],
                                plateID: snapshot
                                    .data[index].data['plate'], //"SUR 360",
                                reason: snapshot.data[index].data[
                                    'reason'], //"Parking in front of fire hydrant",
                                amount: snapshot.data[index].data['fine']
                                    .toString(), //"\$55"
                                foreColor: Color(0xff2BC8D8),
                                backColor: Color(0xffE5F7F8),
                              ),
                            ]);
                          })
                    ]);
              }
            }));
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future _data;
  String uid;
  final Firestore _db = Firestore.instance;

  Future getTickets() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid.toString();

    var firestore = Firestore.instance;

    //print('uid:'+uid);
    DocumentReference userSnapshot =
        firestore.collection('users').document(uid);

    QuerySnapshot qn = await firestore
        .collection('users')
        .document(uid)
        .collection('tickets')
        .getDocuments(); //creates required collections and documents if they do not already exist

    return qn.documents; //array of docements
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
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
                        Text(
                          "Notifications",
                          style: TextStyle(
                              color: Color(0xff241A3C),
                              // fontFamily: 'FuturaBold',
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormPage()));
                            })
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ColumnBuilder(
                        itemCount: 5,
                        itemBuilder: (_, index) {
                          return Column(children: <Widget>[
                            NotificationItem(),
                          ]);
                        })
                  ]);
            }));
  }
}
