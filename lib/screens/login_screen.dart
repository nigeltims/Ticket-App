
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/services/authService.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: codeSent? 
          Column(
            children: <Widget>[
             SizedBox(
                height: 50,
              ),
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
                    Navigator.of(context).pop();
                  }),
                ],
              ),
              SizedBox(
                height: 50,
              ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: PinCodeTextField(
                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.box,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                                      onChanged: (val) {
                                        setState(() {
                                          this.smsCode = val;
                                        });
                                      },
                ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: _buildLoginBtn(),
                  )
            ],
          )




          :


          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    initialValue: "+1",
                    keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Futura',
            ),

            decoration: InputDecoration(
              border: InputBorder.none,
              
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_iphone,
                color: Colors.black,
              ),
              hintText: 'Enter your phone number',
              // hintStyle: kHintTextStyle,
            ),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: _buildLoginBtn()
                      )
            ],
          )
          
          ),
    );
  }








  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
                        onPressed: () {
                        codeSent ? AuthService().signInWithOTP(smsCode, verificationId):verifyPhone(phoneNo);
                      },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CONTINUE',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Futura',
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}