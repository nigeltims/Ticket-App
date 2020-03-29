
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';



class TicketItem extends StatelessWidget {
  final String plateID;
  final String amount;
  final Color backColor;
  final Color foreColor;
  final String reason;
  final DateTime date;
  final String address;
  const TicketItem(
      {this.plateID, this.backColor, this.foreColor, this.reason, this.amount, this.address, this.date});



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      height: 130,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: 
      Row(children: <Widget>[
        Container(
          width: 8,
          height: 130,
      decoration: BoxDecoration(
        color: foreColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          bottomLeft: Radius.circular(7)
        )
      ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(amount, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
                SizedBox(
                  width: 160,
                ),
                Text(DateFormat('yyyy-MM-dd').format(date))
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(plateID, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
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
                Text(address),
              ],
            ),
          ],
        )
      ],)
    );
  }
}