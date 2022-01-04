import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nfc_hospital_manage/UploadFiles.dart';
import 'package:nfc_hospital_manage/page/Reception/AddpatientFD.dart';
import 'package:nfc_hospital_manage/profileEdit.dart';
import 'package:nfc_hospital_manage/widgets/selectDNDialog.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;


class D_HomePage extends StatefulWidget {
  D_HomePage({Key? key, required this.title,required this.user_}) : super(key: key);


  final String title;
  final User user_;

  @override
  _D_HomePageState createState() => _D_HomePageState();



}

class _D_HomePageState extends State<D_HomePage>{

  int _index = 0;
  int _selectedIndex=0;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  late io.File _image;
  bool imageUpdated=false;
  late String profile_image; //1 :network , 0:app memory





  List<Widget> _widgetOptions = <Widget>[

    Container(
      child: FutureBuilder<String>(
        future: Future<String>.delayed(
          const Duration(seconds: 2),
              () => 'Data Loaded',
        ),
        builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            return     Container(
              child: Stack(
                children: [
                  new Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(image: new AssetImage("images/bg.jpg"),fit:BoxFit.fill),
                    ),
                  ),
                  Center(
                    child: Center(
                        child: Column(children:
                        [

                          Row(
                            children: [
                              GestureDetector(child: Container(
                                height: 200,
                                width: 200,
                                child: Card(
                                  child:Container(
                                    height: 198,
                                    width: 198,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 110,
                                          width: 110,
                                          child: Center( child:Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Container(color: Colors.white),
                                                Icon(Icons.nfc_sharp,size:64.0,color: Colors.blue,),
                                                //Icon(Icons.nfc_sharp,size:64.0,color: Colors.blue,)

                                              ])),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 110,
                                          child: Text("Read NFC card",style: TextStyle(fontSize: 14,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
                                        )
                                      ],
                                    ),

                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.green,
                                  margin: EdgeInsets.all(20),

                                ),
                              ),
                                onTap: (){


                                  showDialog(
                                      context: context,builder: (_) => AssetGiffyDialog(
                                    image: Image.asset(
                                      'images/image_nfcScan.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text('READ NFC CARD',
                                      style: TextStyle(
                                          fontSize: 22.0, fontWeight: FontWeight.w600),
                                    ),
                                    description: Text('Place the NFC card no the back of your phone and tap OK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                    entryAnimation: EntryAnimation.BOTTOM,
                                    onOkButtonPressed: () {
                                      ValueNotifier<dynamic> _result = ValueNotifier(null);

                                      print("reading tags");
                                      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                                        _result.value = tag.data;
                                        print(_result.value );
                                        NfcManager.instance.stopSession();
                                      });

                                    },
                                  ) );

                                },
                              ),
                              GestureDetector(child: Container(
                                height: 200,
                                width: 200,
                                child: Card(
                                  child:Container(
                                    height: 198,
                                    width: 198,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 110,
                                          width: 110,
                                          child: Center( child:Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Container(color: Colors.white),
                                                // Icon(Icons.nfc_sharp,size:64.0,color: Colors.blue,),

                                                Icon(Icons.delete_forever,size:64.0,color: Colors.red,)



                                              ])),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 110,
                                          child: Text("Erase NFC Card",style: TextStyle(fontSize: 14,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
                                        )
                                      ],
                                    ),

                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.green,
                                  margin: EdgeInsets.all(20),

                                ),
                              ),
                                onTap: (){


                                  showDialog(
                                      context: context,builder: (_) => AssetGiffyDialog(
                                    image: Image.asset(
                                      'images/image_nfcScan.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text('ERASE NFC CARD',
                                      style: TextStyle(
                                          fontSize: 22.0, fontWeight: FontWeight.w600),
                                    ),
                                    description: Text('Place the NFC card no the back of your phone  and tap OK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                    entryAnimation: EntryAnimation.BOTTOM,
                                    onOkButtonPressed: () {


                                    },
                                  ) );

                                },
                              ),
                            ],
                          ),
/*                  GestureDetector(child: Container(
                    height: 200,
                    width: 400,
                    child: Card(
                      child:Container(
                        height: 198,
                        width: 398,
                        child: Column(
                          children: [
                            Container(
                              height: 110,
                              width: 310,
                              child: Center( child:Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(color: Colors.white),
                                    Image.asset("images/reception.jpg")
                                  ])),
                            ),
                            Container(
                              height: 30,
                              width: 150,
                              child: Text("Login as Receptionist",style: TextStyle(fontSize: 15,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
                            )
                          ],
                        ),

                      ),
                      elevation: 8,
                      shadowColor: Colors.green,
                      margin: EdgeInsets.all(20),

                    ),
                  ),
                    onTap: (){
*//*                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReceptionistLoginPage()),
                      );  *//*


                    },
                  ),*/

                        ],)
                    ),
                  ),
                ],),
            );
          }
          else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          }
          else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );


        },
      ),
    ),

    Container(
      color: Colors.grey,

      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('patients').snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                CollectionReference assignedNurse = FirebaseFirestore.instance.collection('nursepatient');
                CollectionReference assignedDoc = FirebaseFirestore.instance.collection('nursepatient');

                String nurseEmail='No Nurse Assigned';
                String docEmail='No Doctor Assigned';


                assignedNurse.where('nfcId', isEqualTo: data['nfcID'])
                    .get()
                    .then((value) => (){
                  //showSucessDialog(context, " data uploaded");
                  nurseEmail=value.docs.first['nurseEmail'];

                });

                assignedDoc.where('nfcId', isEqualTo: data['nfcID'])
                    .get()
                    .then((value) => (){
                  //showSucessDialog(context, " data uploaded");
                  docEmail=value.docs.first['nurseEmail'];

                });



                return OpenContainer(
                  openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                  return Container(
                    child:ListView(
                        children: <Widget>[
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.deepOrange.shade300],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.5, 0.9],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red.shade300,
                                      minRadius: 35.0,
                                      child: Icon(
                                        Icons.call,
                                        size: 30.0,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      minRadius: 60.0,
                                      child: CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                            'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.red.shade300,
                                      minRadius: 35.0,
                                      child: Icon(
                                        Icons.message,
                                        size: 30.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  data['fname'] +' ' +data['mname']! +" "+data['lname'],
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'NFC ID:'+" " +data['nfcID'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Center(
                              child:Column(
                                children: [

                                  Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.bloodtype,color: Colors.red,size:32),
                                          title:  Text('Blood type :' + data['bloodtype']! ),
                                          subtitle: Text(
                                            data['pcare']!,
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.bloodtype,color: Colors.red,size:32),
                                          title:  Text('Assigned Nurse' ),
                                          subtitle: Text(
                                            nurseEmail,
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),

                                  Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.bloodtype,color: Colors.red,size:32),
                                          title:  Text('Assigned Doctor' ),
                                          subtitle: Text(
                                            nurseEmail,
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            ),

                          ),




                        ]
                    ),
                  );
                },
                  closedBuilder: (BuildContext context, void Function() action) {
                    return Card( child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person,size: 64,color: Colors.red, ),
                            title: Text(data['fname']!+' ' +data['mname']! +" "+data['lname']!),
                            subtitle: Text('NFC ID:'+" " +data['nfcID'] ),
                          ),
                          Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bloodtype,
                                      color: Colors.red,
                                      //size: 32,
                                    ),
                                    Text(" "),
                                    Text(data['bloodtype']),
                                    Text(" "),
                                    Icon(
                                      Icons.airline_seat_individual_suite,
                                      color: Colors.amber,
                                      // size: 32,
                                    ),
                                    Text(" "),
                                    // Text(data['pcare']),


                                  ],
                                ),

                              ]
                          ),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                                TextButton(
                                child: const Text('Assign Nurse'),
                                onPressed: ()  {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => SelectDN(option: 'nurse',patientID: data['nfcID'] ,patientName: data['fname']!+' ' +data['mname']! +" "+data['lname']!,),
                                      fullscreenDialog: true,
                                    ),
                                  );

                                              },
                                ),
                                const SizedBox(width: 8),
                                 TextButton(
                              child: const Text('Assign Doctor'),
                              onPressed: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => SelectDN(option: 'doctor',patientID: data['nfcID'] ,patientName: data['fname']!+' ' +data['mname']! +" "+data['lname']!,),
                                    fullscreenDialog: true,
                                  ),
                                );

                              },
                            ),
                                 const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('Upload Files'),
                                  onPressed: ()  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => UploadfileEdit(title: 'Upload Files',patientID: data['nfcID'] ,patientName: data['fname']!+' ' +data['mname']! +" "+data['lname']!,),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                        },
                                ),
                                const SizedBox(width: 8),
                            ],
                         ),

                        ])


                    );
                  },
                );

              }).toList(),
            );
          }

      ),

    ),

    Container(
      color: Colors.grey,

      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('doctor').snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return OpenContainer(
                  openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                    return Container(
                      child:ListView(
                          children: <Widget>[
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.teal.shade300],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.5, 0.9],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.red.shade300,
                                        minRadius: 35.0,
                                        child: Icon(
                                          Icons.call,
                                          size: 30.0,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        minRadius: 60.0,
                                        child: CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(
                                              'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.red.shade300,
                                        minRadius: 35.0,
                                        child: Icon(
                                          Icons.message,
                                          size: 30.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['fname']! +' ' +data['mname']! +" "+data['lname']!,
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Phone:'+" " +data['phone'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    'Email:'+" " +data['email'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),




                          ]
                      ),
                    );
                  },
                  closedBuilder: (BuildContext context, void Function() action) {
                    return Card( child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person,size: 64,color: Colors.red, ),
                            title: Text(data['fname'] +' ' +data['mname']! +" "+data['lname']),
                            subtitle: Text('Phone:'+" " +data['phone'],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Check Patient'),
                                onPressed: () {
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Upload Files'),
                                onPressed: ()  {
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),

                        ])


                    );
                  },
                );


              }).toList(),
            );
          }

      ),

    ),

    Container(
      color: Colors.grey,

      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('nurse').snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return OpenContainer(
                  openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                    return Container(
                      child:ListView(
                          children: <Widget>[
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.teal.shade300],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.5, 0.9],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.red.shade300,
                                        minRadius: 35.0,
                                        child: Icon(
                                          Icons.call,
                                          size: 30.0,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        minRadius: 60.0,
                                        child: CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(
                                              'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.red.shade300,
                                        minRadius: 35.0,
                                        child: Icon(
                                          Icons.message,
                                          size: 30.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['fname']! +' ' +data['mname']! +" "+data['lname']!,
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Phone:'+" " +data['phone'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    'Email:'+" " +data['email'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),




                          ]
                      ),
                    );
                  },
                  closedBuilder: (BuildContext context, void Function() action) {
                    return Card( child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person,size: 64,color: Colors.red, ),
                            title: Text(data['fname'] +' ' +data['mname']! +" "+data['lname']),
                            subtitle: Text('Phone:'+" " +data['phone'],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Check Patient'),
                                onPressed: () {
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Upload Files'),
                                onPressed: ()  {
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),

                        ])


                    );
                  },
                );


              }).toList(),
            );
          }

      ),

    ),



  ];

  void _tagRead() {
    print("reading tags");
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print(result.value );
      NfcManager.instance.stopSession();
    });
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


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title:  Text(widget.title),backgroundColor: Colors.purple,),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                widget.user_.email.toString(),

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ProfileEdit(title: 'doctor', user_: widget.user_),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airline_seat_flat_sharp),
            label: 'Paitents',
            backgroundColor: Colors.purple,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Doctors',
            backgroundColor: Colors.purple,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Nurse',
            backgroundColor: Colors.purple,

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AddpatientFD(title: 'Register Patient',),
              fullscreenDialog: true,
            ),
          );
        },
        label: const Text('Admit Paitent'),
        icon: const Icon(Icons.add_box_rounded,color: Colors.red,),
        backgroundColor: Colors.amberAccent,

      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

    );
  }

}