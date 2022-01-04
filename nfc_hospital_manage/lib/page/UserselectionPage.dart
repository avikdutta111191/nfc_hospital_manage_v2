import 'package:flutter/material.dart';
import 'package:nfc_hospital_manage/page/Doctor/DoctorLogin.dart';
import 'package:nfc_hospital_manage/page/Nurse/NurseLogin.dart';
import 'package:nfc_hospital_manage/page/Reception/ReceptionLogin.dart';

class UserselectionPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return

          Scaffold(

            body: Stack(
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
                  Container(
                    height: 300,

                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Select login Type",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )
                  ),

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
                                      Image.asset("images/doctor.png")
                                    ])),
                              ),
                              Container(
                                height: 30,
                                width: 110,
                                child: Text("Login as Doctor",style: TextStyle(fontSize: 14,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorLogin()),
                      );

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
                                      Image.asset("images/nurse.png")
                                    ])),
                              ),
                              Container(
                                height: 30,
                                width: 110,
                                child: Text("Login as Nurse",style: TextStyle(fontSize: 14,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NurseLogin()),
                        );
                      },
                    ),
                  ],
                ),
                  GestureDetector(child: Container(
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
                              child: Text("Login as Receptionist",style: TextStyle(fontSize: 14,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.blue),),
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
/*                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReceptionistLoginPage()),
                      );  */

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReceptionLogin()),
                      );
                    },
                  ),

                ],)
              ),
            ),
            ],))

    ;
  }
}