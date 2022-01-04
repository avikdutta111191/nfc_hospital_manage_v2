
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nfc_manager/nfc_manager.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;


class AddpatientFD extends StatefulWidget {
  AddpatientFD({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _AddpatientFDState createState() => _AddpatientFDState();



}

class _AddpatientFDState extends State<AddpatientFD>{




  int _index = 0;
  String _chosenValue='Primary Care';
  String _bloodTypeValue='O RhD positive (O+)';
  DateTime selectedDate = DateTime.now();
  late TextEditingController fname;
  late TextEditingController mname;
  late TextEditingController lname;
  late TextEditingController phone;
  late TextEditingController address;
  //late TextEditingController fname;
  late TextEditingController dob;
  //late TextEditingController fname;
  late TextEditingController nfcID;

  ValueNotifier<dynamic> result = ValueNotifier(null);

  Future<void> addPatient(String fname,String mname,String lname,String phone,String address,String bloodtype,String dob,String pcare,String pcondition,String nfcID,String Admittime) {
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

    // Call the user's CollectionReference to add a new user
    return patients
        .add({
      'fname': fname, // John Doe
      'mname': mname, // Stokes and Sons
      'lname': lname,
      'phone': phone,
      'address': address,
      'bloodtype': bloodtype,
      'dob': dob,
      'pcare': pcare,
      'pcondition': pcondition,
      'nfcID': nfcID,
      'stage':0,
      'admittime':Admittime

    })
        .then((value) => (){
          showSucessDialog(context, " data uploaded");
          print("Patient Added");
        })
        .catchError((error) => (){
          showFailDialog(context,error.toString());
          print("Failed to add user: $error");
        });
  }

  showSucessDialog(BuildContext context, String result) {
    AlertDialog alert = AlertDialog(
      actions: [          FlatButton(
        onPressed: () => Navigator.pop(context, false), // passing false
        child: Text('Close'),
      ),],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Icon(Icons.check_circle, color: Colors.green,),
          SizedBox(
            width: 16,
          ),
          Flexible(child: Text(result)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showNFCDialog(BuildContext context, String result, String nfcId ) {
    AlertDialog alert = AlertDialog(
      actions: [          FlatButton(
        onPressed: (){
          showNFCWriteDialog(context);
          _ndefWrite(nfcID.text);
          Navigator.pop(context, false);
          Navigator.pop(context, false);
          Navigator.pop(context, false);



        }, // passing false
        child: Text('Write to NFC'),
      ),
        FlatButton(
        onPressed: () => Navigator.pop(context, false), // passing false
        child: Text('Cancel'),
      ),],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Icon(Icons.check_circle, color: Colors.green,),
          SizedBox(
            width: 16,
          ),
          Flexible(child: Text(result)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showFailDialog(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      actions: [          FlatButton(
        onPressed: () => Navigator.pop(context, false), // passing false
        child: Text('Close'),
      ),],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Icon(Icons.error_outline_rounded, color: Colors.red,),
          SizedBox(
            width: 16,
          ),
          Flexible(child: Text(message)),
        ],
      ),
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      actions: [          FlatButton(
        onPressed: () => Navigator.pop(context, false), // passing false
        child: Text('Close'),
      ),],
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Posting ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNFCWriteDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        children: [
          //CircularProgressIndicator(),
          Icon(Icons.nfc_sharp, color: Colors.blue, size: 128.0,),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Place the NFC Card ")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _tagRead() {
    print("reading tags");
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print(result.value );
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite(String nfcID,) {
    print("write tags 1");

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        print("write tags 2");

        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(nfcID),
        //NdefRecord.createUri(Uri.parse('https://flutter.dev')),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        NdefRecord.createExternal(
            'com.example', 'nfc_hospital_manage', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  String get10DigitNumber(){
    Random random = Random();
    String number = '';
    for(int i = 0; i < 10; i++){
      number = number + random.nextInt(9).toString();
    }
    return number;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fname= TextEditingController();
    mname= TextEditingController();
    lname= TextEditingController();
    address= TextEditingController();
    dob= TextEditingController();
    phone= TextEditingController();

    nfcID= TextEditingController();

    nfcID.text=get10DigitNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6200EE),
        title: Text('Add ptient Details'),
        actions: [
           IconButton(
                    icon: const Icon(Icons.add_box),
                    tooltip: 'Save',
                    onPressed: () async{}),
        ],
      ),

      body:SingleChildScrollView(
      child:Center(
        child:  Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 3) {
              setState(() {
                _index += 1;
              });
            }
            if(_index ==4){

              print('step4 reached');
              showLoaderDialog(context);
              addPatient(
                fname.text,
                mname.text,
                lname.text,
                phone.text,
                address.text,
                _bloodTypeValue,
                "${selectedDate.toLocal()}".split(' ')[0],
                _chosenValue,
                "bad",
                nfcID.text,
                DateTime.now().toString()

              );
              Navigator.pop(context, false);

              showDialog(
                  context: context,builder: (_) => AssetGiffyDialog(
                image: Image.asset(
                  'images/image_nfcScan.gif',
                  fit: BoxFit.cover,
                ),
                title: Text('Write NfcID to NFC CARD',
                  style: TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
                description: Text('Place the NFC card no the back of your phone and tap OK',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                entryAnimation: EntryAnimation.BOTTOM,
                onOkButtonPressed: () {
                  _ndefWrite(nfcID.text);
                  Navigator.pop(context, false);
                  Navigator.pop(context, false);


                },
              ) );

            }

          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: <Step>[
            Step(
              title: const Text('Step 1 Enter Name'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          children: [
                              SizedBox(
                              height: 16  ,
                              ),
                            //firstname
                            TextFormField(
                              controller: fname,

                              keyboardType: TextInputType.name,
                              minLines: 1,//Normal textInputField will be displayed
                              maxLines: 1,
                              cursorColor: Theme.of(context).cursorColor,
                              //initialValue: '',
                              maxLength: 200,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person_add),
                                labelText: 'First Name',
                                border: OutlineInputBorder(),

                                labelStyle: TextStyle(
                                  color: Color(0xff143957),
                                ),
                                helperText: 'First Name of Patient',
                                suffixIcon: Icon(
                                  Icons.check_circle,
                                  //color: Colors.grey,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff143957)),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 16  ,
                            ),
                            //middlename
                            TextFormField(
                              controller: mname,

                              keyboardType: TextInputType.name,
                              minLines: 1,//Normal textInputField will be displayed
                              maxLines: 1,
                              cursorColor: Theme.of(context).cursorColor,
                              //initialValue: '',
                              maxLength: 200,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person_add),
                                labelText: 'Middle Name',
                                border: OutlineInputBorder(),

                                labelStyle: TextStyle(
                                  color: Color(0xff143957),
                                ),
                                helperText: 'Middle Name of Patient',

                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff143957)),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 16  ,
                            ),
                            //lastname
                            TextFormField(
                              controller: lname,

                              keyboardType: TextInputType.name,
                              minLines: 1,//Normal textInputField will be displayed
                              maxLines: 1,
                              cursorColor: Theme.of(context).cursorColor,
                              //initialValue: '',
                              maxLength: 200,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person_add),
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),

                                labelStyle: TextStyle(
                                  color: Color(0xff143957),
                                ),
                                helperText: 'Last Name of Patient',
                                suffixIcon: Icon(
                                  Icons.check_circle,
                                  //color: Colors.grey,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff143957)),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 16  ,
                            ),
                          ])
                    ),
                  )),
            ),
            Step(
              title: Text('Step 2 Enter Contact Details'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            children: [
                              SizedBox(
                                height: 16  ,
                              ),
                              //phone

                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 2.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Phone N.o',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 2.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          controller: phone,
                                          //initialValue: widget.userC.firstName,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.phone),
                                            hintText: '',
                                            labelText: 'Phone N.o',
                                          ),
                                          //enabled: !_status,
                                          //autofocus: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 16  ,
                              ),
                              //Address
                              //address

                              TextFormField(
                                controller: address,
                                //keyboardType: TextInputType.multiline,
                                minLines: 7,//Normal textInputField will be displayed
                                maxLines: 20,
                                cursorColor: Theme.of(context).cursorColor,
                                // initialValue: 'type the content of your bloody blog mate',
                                maxLength: 1000,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home),
                                  labelText: 'Address',
                                  helperText: 'Address',
                                  border: OutlineInputBorder(),

                                  labelStyle: TextStyle(
                                    color: Color(0xff143957),
                                  ),
                                ),
                              ),

                            ])
                    ),
                  )),
            ),
            Step(
              title: Text('Step 2 Enter Patient Details'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            children: [
                              SizedBox(
                                height: 16  ,
                              ),
                              //phone
                              Row(
                                children: [
                                  new Icon(Icons.bloodtype,color: Colors.red,),

                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 2.0, right: 20.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Blood Type',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  DropdownButton<String>(
                                    focusColor:Colors.blue,
                                    value: _bloodTypeValue,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.blue),
                                    iconEnabledColor:Colors.black,
                                    items: <String>[
                                      'A RhD positive (A+)',
                                      'A RhD negative (A-)',
                                      'B RhD positive (B+)',
                                      'B RhD negative (B-)',
                                      'O RhD positive (O+)',
                                      'O RhD negative (O-)',
                                      'AB RhD positive (AB+)',
                                      'AB RhD negative (AB-)'
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style:TextStyle(color:Colors.black),),
                                      );
                                    }).toList(),
                                    hint:Text(
                                      "Blood Type",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: ( value) {
                                      setState(() {
                                        _bloodTypeValue = value.toString();
                                      });
                                    },
                                  ),

                                ],
                              ),

                              SizedBox(
                                height: 16  ,
                              ),

                              Row(
                                children: [
                                  new Icon(Icons.date_range),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 2.0, right: 20.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Date of Birth',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),

                                  RaisedButton(
                                    onPressed: () => _selectDate(context), // Refer step 3
                                    child:Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16  ,
                                  ),

                                ],
                              )




                            ])
                    ),
                  )),
            ),
            Step(
              title: const Text('Step 3 Enter Patient Symtomps'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: Center(
                  child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 2.0, right: 20.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Types of Patient Care',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          DropdownButton<String>(
                            focusColor:Colors.blue,
                            value: _chosenValue,
                            //elevation: 5,
                            style: TextStyle(color: Colors.blue),
                            iconEnabledColor:Colors.black,
                            items: <String>[
                              'Primary Care',
                              'Specialty Care',
                              'Emergency Care',
                              'Urgent Care',
                              'Long-term Care',
                              'Hospice Care',
                              'Mental Healthcare',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style:TextStyle(color:Colors.black),),
                              );
                            }).toList(),
                            hint:Text(
                              "Patient Condition",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: ( value) {
                              setState(() {
                                _chosenValue = value.toString();
                              });
                            },
                          ),

                        ],
                      )


                    ],

                  )))
              ),
            ),
            Step(
              title: const Text('Step 4 Assign patient NFC'),
              content: Container(
                  child: TextFormField(
                    controller: nfcID,

                    keyboardType: TextInputType.name,
                    minLines: 1,//Normal textInputField will be displayed
                    maxLines: 1,
                    cursorColor: Theme.of(context).cursorColor,
                    //initialValue: '',
                    maxLength: 200,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_add),
                      labelText: 'NFC ID',
                      border: OutlineInputBorder(),

                      labelStyle: TextStyle(
                        color: Color(0xff143957),
                      ),
                      helperText: 'NFC ID of Patient',
                      suffixIcon: Icon(
                        Icons.check_circle,
                        //color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff143957)),
                      ),
                    ),
                  ),

              ),
            ),




          ],
        ),
      ),)

    /*  bottomNavigationBar: BottomAppBar(
          color: Color(0xff143957),
          child: Row(
            children: [
          IconButton(icon: Icon(Icons.camera, color: Colors.white,),
              onPressed: () {
          //  _imgFromCamera();
          }),
          IconButton(icon: Icon(Icons.photo, color: Colors.white,),
              onPressed: () {
            //_imgFromGallery();
          }),
          ]
         )
      ) */
    );
  }
}





