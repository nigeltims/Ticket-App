import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ticket_app/homePage.dart';
import 'package:image_picker/image_picker.dart';


void main() => runApp(FormPage());

class FormPage extends StatelessWidget {
  final String ticketNumber, licensePlate, fine, codeNo, reason, firstName, lastName, infractionAddress, documentid, status;
  final DateTime birthdate, infractionDate;
  final bool newticket;

  const FormPage(
      {Key key,
      this.status,
      this.newticket,
      this.reason,
      this.ticketNumber,
      this.licensePlate,
      this.fine,
      this.codeNo,
      this.firstName,
      this.lastName,
      this.birthdate, 
      this.infractionDate, 
      this.infractionAddress,
      this.documentid,
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WizardForm(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        reason: reason,
        infractionAddress: infractionAddress,
        infractionDate: infractionDate,
        ticketNumber: ticketNumber,
        fine: fine,
        licensePlate: licensePlate,
        codeNo: codeNo,
        newticket:newticket,
        documentid:documentid,
      ),
    );
  }
}

class WizardFormBloc extends FormBloc<String, String> {
  static String ticketNumber;

  WizardFormBloc({String ticketNumber, String licensePlate, String fine,
      String codeNo, DateTime infractionDate, String location, String firstName, String lastName, DateTime birthDate, String reason, bool newticket, String documentid, String ticketstatus}) {
    
    this.status = ticketstatus;
    this.firestoreDocumentID = documentid;
    this.isnewticket = newticket;
    this.firstNameform = TextFieldBloc(initialValue: firstName, validators: [FieldBlocValidators.required]);
    this.lastNameform = TextFieldBloc(initialValue: lastName, validators: [FieldBlocValidators.required]);
    this.birthDateform = InputFieldBloc<DateTime, Object>(initialValue: birthDate, validators: [FieldBlocValidators.required]);
    this.reasonform = TextFieldBloc(initialValue: reason, validators: [FieldBlocValidators.required]);

    this.fineForm = TextFieldBloc(
        initialValue: fine, validators: [FieldBlocValidators.required]);
    this.code = TextFieldBloc(
        initialValue: codeNo, validators: [FieldBlocValidators.required]);
    this.ticket_id = TextFieldBloc(
        initialValue: ticketNumber, validators: [FieldBlocValidators.required]);
    this.plate = TextFieldBloc(
        initialValue: licensePlate, validators: [FieldBlocValidators.required]);
    this.address = TextFieldBloc(
        initialValue: location, validators: [FieldBlocValidators.required]);
    this.infractionDateform = InputFieldBloc<DateTime, Object>(
        initialValue: infractionDate, validators: [FieldBlocValidators.required]);
    print('Constructor location is $location');
    addFieldBlocs(
      step: 0,
      fieldBlocs: [firstNameform, lastNameform, birthDateform],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [ticket_id, plate, code, fineForm, address, infractionDateform],
    );
    addFieldBlocs(
      step: 2,
      fieldBlocs: [reasonform],
    );
  }
  
  String status;
  String firestoreDocumentID;
  bool isnewticket;
  TextFieldBloc reasonform;
  TextFieldBloc firstNameform;
  TextFieldBloc lastNameform;
  InputFieldBloc<DateTime, Object> birthDateform;
  TextFieldBloc fineForm;
  TextFieldBloc code;
  TextFieldBloc ticket_id;
  TextFieldBloc plate;
  TextFieldBloc address;
  InputFieldBloc<DateTime, Object> infractionDateform;

  //final FirebaseStorage _storage = FirebaseStorage(storageBucket:'gs://ticketapp-759c2.appspot.com');
  StorageUploadTask _uploadTask;

  List <File> imagesList = [];

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      emitSuccess();
    } else if (state.currentStep == 1) {
      emitSuccess();
    } else if (state.currentStep == 2) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();

      var numTickets;
      Firestore.instance.collection('users').document(uid).get().then((DocumentSnapshot) => numTickets = DocumentSnapshot.data['num_tickets'].toString());
      numTickets +=1 ;

      Firestore.instance.collection('users').document(uid).setData({
        'first name': firstNameform.value,
        'last name': lastNameform.value,
        'birthdate': birthDateform.value,
        'num_tickets': numTickets
      });
      
      if (isnewticket){
        Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tickets')
          .document()
          .setData({
        'reason': reasonform.value,
        'ticket_id': ticket_id.value,
        'plate': plate.value,
        'code': code.value,
        'fine': fineForm.value,
        'infractionAddress': address.value,
        'infractionDate': infractionDateform.value,
        'status': 'Starting Contest',
      });
      }
      else if (!isnewticket){
        Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tickets')
          .document(firestoreDocumentID)
          .setData({
        'reason': reasonform.value,
        'ticket_id': ticket_id.value,
        'plate': plate.value,
        'code': code.value,
        'fine': fineForm.value,
        'infractionAddress': address.value,
        'infractionDate': infractionDateform.value,
        'status': status,
      });

      }

      if (imagesList.length > 0){

        for(var i = 0 ; i <imagesList.length; i++ ) { 
          String filePath = 'images/$uid/${ticket_id.value}/${DateTime.now()}.png';
          final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(filePath);
          final StorageUploadTask task = firebaseStorageRef.putFile(imagesList[i]);
        }
      }
 
      emitSuccess();
    }
  }

  dispose() {
    firstNameform.close();
    lastNameform.close();
    birthDateform.close();
    reasonform.close();
    fineForm.close();
    code.close();
    ticket_id.close();
    plate.close();
    address.close();
    infractionDateform.close();
  }
}

class WizardForm extends StatefulWidget {
  final String ticketNumber, licensePlate, fine, codeNo, reason, firstName, lastName, infractionAddress, documentid, status;
  DateTime birthdate, infractionDate;
  
  bool newticket;

  WizardForm({
    Key key,
    this.status,
    this.reason,
    this.ticketNumber,
    this.licensePlate,
    this.fine,
    this.codeNo,
    this.firstName,
    this.lastName,
    this.birthdate, 
    this.infractionDate, 
    this.infractionAddress, 
    this.newticket, 
    this.documentid,
  }) : super(key: key);
  @override
  _WizardFormState createState() => _WizardFormState();
}

class _WizardFormState extends State<WizardForm> {
  List <File> imageList = [];
  File tempImage;

  var _type = StepperType.horizontal;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardFormBloc(
          documentid: widget.documentid,
          newticket: widget.newticket,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthDate: widget.birthdate,
          reason: widget.reason,
          ticketNumber: widget.ticketNumber,
          licensePlate: widget.licensePlate,
          fine: widget.fine,
          codeNo: widget.codeNo,
          infractionDate: widget.infractionDate,
          location: widget.infractionAddress),
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              //resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: FormBlocListener<WizardFormBloc, String, String>(
                  onSubmitting: (context, state) => LoadingDialog.show(context),
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.stepCompleted == state.lastStep) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => SuccessScreen()));
                    }
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child: StepperFormBlocBuilder<WizardFormBloc>(
                    type: _type,
                    physics: ClampingScrollPhysics(),
                    stepsBuilder: (formBloc) {
                      return [
                        _personalStep(formBloc),
                        _ticketStep(formBloc),
                        _argumentStep(formBloc),
                      ];
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  FormBlocStep _argumentStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: Text('Reason'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.reasonform,
            maxLines: 5,
            enableOnlyWhenFormBlocCanSubmit: true,
            decoration: InputDecoration(
              labelText: 'Please State Your Reasoning',
              isDense: true,
              filled: true,
            ),
          ),
          ButtonTheme(
          minWidth: 200,
          height:40,
          child:FlatButton(
            color: Color(0xffbcf2f5),
            child: Text('Add Photo From Camera',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () async {
              var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
              
              setState(() {
                tempImage = tempStore;
                print(tempImage.lengthSync());
              });

              File cropped = await ImageCropper.cropImage(
                sourcePath: tempImage.path,
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: Color(0xff2BC8D8),
                  toolbarWidgetColor: Colors.white,
                ),
                iosUiSettings: IOSUiSettings(
                  minimumAspectRatio: 1.0,
                )
              );

              setState((){
                imageList.add(cropped ?? tempImage);
              });              

              wizardFormBloc.imagesList = imageList;

            },
          ),
          ),
          SizedBox(height: 2,),
          ButtonTheme(
          minWidth: 200,
          height:40,
          child:FlatButton(
            color: Color(0xffbcf2f5),
            child: Text('Add Photo From Gallery',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () async {
              var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);
              setState(() {
                tempImage = tempStore;
                print(tempImage.lengthSync());
              });

              File cropped = await ImageCropper.cropImage(
                sourcePath: tempImage.path,
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: Color(0xff2BC8D8),
                  toolbarWidgetColor: Colors.white,
                ),
                iosUiSettings: IOSUiSettings(
                  minimumAspectRatio: 1.0,
                )
              );

              setState((){
                imageList.add(cropped ?? tempImage);
              });        

              wizardFormBloc.imagesList = imageList;      

            },
          ),
          ),
          SizedBox(height: 5,),
          Container(
            height:100,
            child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:imageList.length,
              itemBuilder: (context,index){
                return Row(children: <Widget>[
                  Image.file(
                    imageList[index],
                    width:100,
                    height:100,
                  ),
                  SizedBox(
                    width:10,)
                ]
                );
              }
          ))

          ],
      ),
    );
  }

  FormBlocStep _personalStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: Text('Personal'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.firstNameform,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.lastNameform,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: wizardFormBloc.birthDateform,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            format: DateFormat('yyyy-MM-dd'),
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.cake),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _ticketStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: Text('Ticket'),
      content:Column(
        children: <Widget>[
          Container(
            child: Text('Please verify the following information:'),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.ticket_id,
            decoration: InputDecoration(
              labelText: 'Ticket ID',
              prefixIcon: Icon(Icons.bookmark_border),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.plate,
            decoration: InputDecoration(
              labelText: 'License Plate',
              prefixIcon: Icon(Icons.personal_video),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.code,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Infraction Code',
              prefixIcon: Icon(Icons.cancel),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.fineForm,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Fine Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.address,
            decoration: InputDecoration(
              labelText: 'Address of Infraction',
              prefixIcon: Icon(Icons.pin_drop),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: wizardFormBloc.infractionDateform,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            format: DateFormat('yyyy-MM-dd'),
            decoration: InputDecoration(
              labelText: 'Date of Infraction',
              prefixIcon: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
      );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, size: 100, color: Color(0xff2BC8D8)),
            SizedBox(height: 10),
            Text(
              'Submitted',
              style: TextStyle(
                fontSize: 54,
                color: Colors.black,
                fontFamily: 'Futura',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(25.0),
              width: double.infinity,
              child: RaisedButton(
                elevation: 5.0,
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomePage())),
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.white,
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Color(0xFF527DAA),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Futura',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
