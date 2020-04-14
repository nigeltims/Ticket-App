

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ticket_app/form.dart';
import 'package:ticket_app/listpage.dart';

class TicketItem extends StatelessWidget {
  final String plateID;
  final String amount;
  final Color backColor;
  final Color foreColor;
  final String reason;
  final String documentID;
  final String ticketNumber;
  final String code;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final DateTime infractionDate;
  final String infractionAddress;
  final String status;
  final Function listPageRefresh;

  
  const TicketItem(
      {this.listPageRefresh,
      this.plateID,
      this.backColor,
      this.foreColor,
      this.reason,
      this.amount,
      this.documentID,
      this.ticketNumber,
      this.code,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.infractionAddress,
      this.infractionDate,
      this.status});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(context:context, builder: (BuildContext context) => ticketDetail(context));
          print("tapped on container");
        },
        child: Container(
            width: 315,
            height: 130,
            decoration: BoxDecoration(
                color: backColor,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Row(
              children: <Widget>[
                Container(
                  width: 8,
                  height: 130,
                  decoration: BoxDecoration(
                      color: foreColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          bottomLeft: Radius.circular(7))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '\$' + amount,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 130,
                        ),
                        Text(DateFormat('yyyy-MM-dd').format(infractionDate))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          plateID,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                          height: 30,
                        ),
                        Text(reason),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        Text(infractionAddress),
                      ],
                    ),
                  ],
                )
              ],
            )
          )
        );
  }

  Widget ticketDetail(context){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
      ),

      // child: DialogButton(
      //     child: Text(
      //       "Edit",
      //       style: TextStyle(color: Colors.white, fontSize: 20),
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => new FormPage(
      //                 documentid: documentID,
      //                 newticket: false,
      //                 firstName: firstName,
      //                 lastName: lastName,
      //                 birthdate: birthDate,
      //                 reason: reason,
      //                 ticketNumber: ticketNumber, 
      //                 fine: amount,
      //                 licensePlate: plateID,
      //                 codeNo: code, 
      //                 infractionDate: infractionDate,
      //                 infractionAddress: infractionAddress,
      //           )));
      //           },
      //     width: 120,
      //   ),

      child: new Container(
              width: 315,
              height: 255,//230,//130,
              decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 255,//230,//130,
                    decoration: BoxDecoration(
                        color: foreColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomLeft: Radius.circular(7))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Status: ' + status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // SizedBox(
                          //   width: 130,
                          // ),
                          //Text(DateFormat('yyyy-MM-dd').format(infractionDate))
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Fine: \$' + amount,
                            style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 25,
                          ),
                          Text('Ticket Number: ' + ticketNumber,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 25,
                          ),
                          Text('License Plate: ' + plateID,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20, height: 25),
                          Text('Ticket Date: '+DateFormat('yyyy-MM-dd').format(infractionDate))
                      ],),
                      // SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 25,
                          ),
                          Text('Reason: ' + reason),
                        ],
                      ),
                      // SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 25,
                          ),
                          Text('Address: ' + infractionAddress),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          FlatButton(
                            color: Color(0xffbcf2f5),
                            child: Text('Edit',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new FormPage(
                                        status:status,
                                        documentid: documentID,
                                        newticket: false,
                                        firstName: firstName,
                                        lastName: lastName,
                                        birthdate: birthDate,
                                        reason: reason,
                                        ticketNumber: ticketNumber, 
                                        fine: amount,
                                        licensePlate: plateID,
                                        codeNo: code, 
                                        infractionDate: infractionDate,
                                        infractionAddress: infractionAddress,
                                  )));
                            },),
                          SizedBox(width: 20,),
                          FlatButton(
                            color: Color(0xffbcf2f5),
                            child: Text('Delete',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            ),
                            onPressed: (){
                              showDeleteDialog(context);
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              
            )));

  }

  
// user defined function
  void showDeleteDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Ticket?"),
          content: new Text("This will delete your ticket, and you will have to re-submit the ticket."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Accept'),
              onPressed: () async{

              FirebaseUser user = await FirebaseAuth.instance.currentUser();
              String uid = user.uid.toString();

              Firestore.instance.collection('users').document(uid).collection('tickets').document(documentID).delete();
              Navigator.of(context).pop(); //pop the dialog
              Navigator.of(context).pop(); //pop the card detail page
              listPageRefresh();

            }, )
          ],
        );
      },
    );
  }

}

