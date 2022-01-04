import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;


class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key? key, required this.title,required this.user_}) : super(key: key);


  final String title;
  final User user_;
  @override
  _ProfileEditState createState() => _ProfileEditState();



}

class _ProfileEditState extends State<ProfileEdit>{
  late TextEditingController fname;
  late TextEditingController mname;
  late TextEditingController lname;
  late TextEditingController phone;
  late TextEditingController address;

  late String fname_;
  late String mname_;
  late String lname_;
  late String phone_;
  late String address_;

  late String docid_;


  Future<void> addGetProfileData(String email,String type) {
    CollectionReference users = FirebaseFirestore.instance.collection(type);

    // Call the user's CollectionReference to add a new user
    return users
        .where('email', isEqualTo: email)
        .get()
        .then((value) => (){
      //showSucessDialog(context, " data uploaded");
      docid_= value.docs.first.id;
      print("Data__"+docid_!);
    })
        .catchError((error) => (){
      //  showFailDialog(context,error.toString());
      print("Failed to add user: $error");
    });
  }

  Future<void> updateProfileData(String email,String type) async {
    CollectionReference users = FirebaseFirestore.instance.collection(type);

    // Call the user's CollectionReference to add a new user
    bool updated=false;

    return users.doc(docid_)
                 .update({
                     'fname':fname.text,
                     'mname':mname.text,
                     'lname':lname.text,
                     'phone':phone.text,
                     'address':address.text,
                  })
                 .then((value) => print("User Updated"))
                 .catchError((error) => print("Failed to update user: $error"));



  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fname= TextEditingController();
    mname= TextEditingController();
    lname= TextEditingController();
    address= TextEditingController();
    phone= TextEditingController();
    addGetProfileData(widget.user_.email.toString(),widget.title);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
                  backgroundColor: Color(0xFF6200EE),
                  title: Text(widget.title),
                  actions: [
                  IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save',
                  onPressed: () async{
                    updateProfileData(widget.user_.email.toString(),widget.title);
                    Navigator.pop(context, false);


                  }),
                  ],
                  ),

          body:Container(
            child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(widget.title) .where('email',isEqualTo:widget.user_.email ).limit(1).snapshots(),
                    builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                return Text('Something went wrong');
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 200,
                                        child: CircularProgressIndicator(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text('Awaiting result...'),
                                      )
                                    ],
                                  ),
                                );
                                }
                                return  ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document)
                                {
                                  docid_=document.id;
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                                  phone.text=data['phone']!;
                                  address.text=data['address']!;

                                  print(data['fname']);
                                  return Card(

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
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
                                                      labelText: data['fname']!,
                                                      border: OutlineInputBorder(),

                                                      labelStyle: TextStyle(
                                                        color: Color(0xff143957),
                                                      ),
                                                      helperText: 'First Name of ' + widget.title,
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
                                                      labelText: data['mname']!,
                                                      border: OutlineInputBorder(),

                                                      labelStyle: TextStyle(
                                                        color: Color(0xff143957),
                                                      ),
                                                      helperText: 'Middle Name of '+ widget.title,

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
                                                      labelText: data['mname']!,
                                                      border: OutlineInputBorder(),

                                                      labelStyle: TextStyle(
                                                        color: Color(0xff143957),
                                                      ),
                                                      helperText: 'Last Name of ' + widget.title,
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
                                      )
                                    ]
                                  )
                                  );

                                }).toList(),
                                );


                                }
          )
          )


        );
  }
}