import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:ticket_app/homePage.dart';

void main() => runApp(FormPage());

class FormPage extends StatelessWidget {
  final String ticketNumber, licensePlate, fine, codeNo;
  const FormPage(
      {Key key, this.ticketNumber, this.licensePlate, this.fine, this.codeNo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WizardForm(
        ticketNumber: ticketNumber,
        fine: fine,
        licensePlate: licensePlate,
        codeNo: codeNo,
      ),
    );
  }
}

class WizardFormBloc extends FormBloc<String, String> {
  static String ticketNumber;
  final firstName = TextFieldBloc();

  final lastName = TextFieldBloc();

  final gender = SelectFieldBloc(
    items: ['Male', 'Female'],
  );

  final birthDate = InputFieldBloc<DateTime, Object>();

  final reason = TextFieldBloc();

  WizardFormBloc(
      String ticketNumber, String licensePlate, String fine, String codeNo) {
    this.fineForm = TextFieldBloc(
        initialValue: fine, validators: [FieldBlocValidators.required]);
    this.code = TextFieldBloc(
        initialValue: codeNo, validators: [FieldBlocValidators.required]);
    this.ticket_id = TextFieldBloc(
        initialValue: ticketNumber, validators: [FieldBlocValidators.required]);
    this.plate = TextFieldBloc(
        initialValue: licensePlate, validators: [FieldBlocValidators.required]);
    this.address = TextFieldBloc(
      validators: [FieldBlocValidators.required]);
    addFieldBlocs(
      step: 0,
      fieldBlocs: [firstName, lastName, gender, birthDate],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [ticket_id, plate, code, fineForm, address],
    );
    addFieldBlocs(
      step: 2,
      fieldBlocs: [reason],
    );
  }

  TextFieldBloc fineForm;
  TextFieldBloc code;
  TextFieldBloc ticket_id;
  TextFieldBloc plate;
  TextFieldBloc address;

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      emitSuccess();
    } else if (state.currentStep == 1) {
      emitSuccess();
    } else if (state.currentStep == 2) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      Firestore.instance.collection('users').document(uid).collection('tickets').document().setData(
        {'first name':firstName.value,
        'last name': lastName.value,
        'gender': gender.value,
        'birthdate': birthDate.value,
        'reason': reason.value,
        'ticket_id': ticket_id.value,
        'plate': plate.value,
        'code': code.value,
        'fine': fineForm.value,
        'address': address.value});
      emitSuccess();
    }
  }

  dispose(){
    firstName.close();
    lastName.close();
    gender.close();
    birthDate.close();
    reason.close();
    fineForm.close();
    code.close();
    ticket_id.close();
    plate.close();
    address.close();
  }

}

class WizardForm extends StatefulWidget {
  final String ticketNumber, licensePlate, fine, codeNo;
  WizardForm(
      {Key key, this.ticketNumber, this.licensePlate, this.fine, this.codeNo})
      : super(key: key);
  @override
  _WizardFormState createState() => _WizardFormState();
}

class _WizardFormState extends State<WizardForm> {
  var _type = StepperType.vertical;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardFormBloc(
          widget.ticketNumber, widget.licensePlate, widget.fine, widget.codeNo),
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
              resizeToAvoidBottomInset: false,
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
      title: Text('Reasoning'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.reason,
            maxLines: 10,
            enableOnlyWhenFormBlocCanSubmit: true,
            decoration: InputDecoration(
              labelText: 'Please State Your Reasoning',
              isDense: true,
              filled: true,
            ),
          ),
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
            textFieldBloc: wizardFormBloc.firstName,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.lastName,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          RadioButtonGroupFieldBlocBuilder<String>(
            selectFieldBloc: wizardFormBloc.gender,
            itemBuilder: (context, value) => value,
            decoration: InputDecoration(
              labelText: 'Gender',
              prefixIcon: SizedBox(),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: wizardFormBloc.birthDate,
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
      title: Text('Ticket Information'),
      content: Column(
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
