import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';



import 'package:loading_overlay/loading_overlay.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage =   FirebaseStorage.instance;

class SelectDN extends StatefulWidget {
  SelectDN({Key? key, required this.option, required this.patientID, required this.patientName}) : super(key: key);


  final String option;
  final String patientID;
  final String patientName;

  @override
  _SelectDNState createState() => _SelectDNState();

}

class _SelectDNState extends State<SelectDN>with SingleTickerProviderStateMixin{
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=false;

  }

  @override
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff143957),
          title: Text('Select ' + widget.option),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Post',
              onPressed: () async{

              },
            )
          ],
        ),
        body:Center(
               child:Center(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection(widget.option).snapshots(),
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

                                    return Card(
                                      child:ListTile(
                                        leading: Icon(Icons.person,size: 32,color: Colors.red, ),
                                        title: Text(data['email']!),
                                        onTap: (){
                                          CollectionReference itemCreate = FirebaseFirestore.instance.collection(widget.option+"patient");
                                          itemCreate.add({
                                            'nfcId': widget.patientID, // John Doe
                                            'nurseEmail':data['email']!, // Stokes and Sons

                                          })
                                          .then((value) => (){
                                            Navigator.pop(context, false);

                                          })
                                          .catchError((error) => print("Failed to add user: $error"));
                                          Navigator.pop(context, false);

                                        },
                                        //subtitle: Text('NFC ID:'+" " +data['nfcID'] ),
                                      ),
                                    );

                                  }).toList(),
                                );

                              }
                          )
                      ),



              )
      ),
    );
  }


}
