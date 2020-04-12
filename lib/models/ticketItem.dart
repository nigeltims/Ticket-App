
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ticket_app/form.dart';

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
  
  const TicketItem(
      {this.plateID,
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
      this.infractionDate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          ticketDetail(context).show();
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
                          amount,
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

  ticketDetail(context){
    return Alert(
      style: AlertStyle(
        isCloseButton: false,
      ),
      buttons:[
         DialogButton(
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new FormPage(
                      documentid: documentID,
                      newticket: false,
                      firstName: firstName,
                      lastName: lastName,
                      birthdate: birthDate,
                      reason: reason,
                      ticketNumber: ticketNumber, //TODO: change this, firebase
                      fine: amount,
                      licensePlate: plateID,
                      codeNo: code, //TODO: change this, firebas
                      infractionDate: infractionDate,
                      infractionAddress: infractionAddress,
                )));
                },
          width: 120,
        )
      ] ,
      title: "Ticket Details",
      context: context,
      content: new Container(
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
              
            )));

  }
}