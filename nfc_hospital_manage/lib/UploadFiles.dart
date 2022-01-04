import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'dart:convert';
import 'dart:io' as io;
import 'package:image/image.dart' as im;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jiffy/jiffy.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage =   FirebaseStorage.instance;

class UploadfileEdit extends StatefulWidget {
  UploadfileEdit({Key? key, required this.title, required this.patientID, required this.patientName}) : super(key: key);


  final String title;
  final String patientID;
  final String patientName;

  @override
  _UploadfileEditState createState() => _UploadfileEditState();

}

class _UploadfileEditState extends State<UploadfileEdit>with SingleTickerProviderStateMixin{
  late TextEditingController Docname;

  final titleTF = TextEditingController();
  final contentTF = TextEditingController();
   io.File _image=io.File('t');
  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Docname= TextEditingController();


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
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Post',
              onPressed: () async{

                try{
                  setState(() {
                    isLoading = true;
                  });
                  if(_image!=null) {

                    //print(_image.path);
                    // Image _imageResiezd= Image(image: ResizeImage(FileImage(_image), width: 252, height: 252));
                    im.Image? image = im.PngDecoder().decodeImage(_image.readAsBytesSync().buffer.asUint8List());
                    // im.decodeJpg(_image.readAsBytesSync());

                    im.Image thumbnail = im.copyResize(image!, width: 300,height: 300);
                    final path = await _localPath;
                    io.File('$path/temp.jpg').writeAsBytesSync(im.encodeJpg(thumbnail));

                    var id = await _uploadMediaFuture(io.File('$path/temp.jpg'));
                    // var id = jsonDecode(jsonReturn);
                    //print("mediaid "+res["id"]);
                   // _CreateWithMediafuture(titleTF.text,contentTF.text, id.toString(),context);
                  }
                 // _Createfuture(titleTF.text,contentTF.text,context);
                }catch(e){

                  setState(() {
                    isLoading = false;
                  });

                  Fluttertoast.showToast(
                      msg: "Failed to upload photo, Please check your photo again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
            )
          ],
        ),
        body: Center(
            child: new Container(
              color: Colors.white,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[

                      SizedBox(
                        height: 16  ,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child:
                            GestureDetector(
                                  child:
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage("images/doctor.png"),
                                        radius: 24,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
/*                                                  Text(
                                                      snapshot.data[index].title,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18),
                                                    ),*/
                                          Text(
                                            widget.patientName,
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Color(0xff143957),
                                                fontSize: 16),
                                          ),
                                          Text(
                                            'NFC ID:'+" " +widget.patientID,
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Color(0xff143957),
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  onTap: () {
                                  },
                                )

                      ),
                      Padding(  padding: EdgeInsets.all(12),
                        child: Column(

                          children:<Widget> [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Upload Patient Files',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff143957),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12  ,
                            ),

                            TextFormField(
                              controller: titleTF,

                              keyboardType: TextInputType.multiline,
                              minLines: 1,//Normal textInputField will be displayed
                              maxLines: 2,
                              cursorColor: Theme.of(context).cursorColor,
                              //initialValue: '',
                              maxLength: 200,
                              decoration: InputDecoration(
                                icon: Icon(Icons.view_headline),
                                labelText: 'Title',
                                border: OutlineInputBorder(),

                                labelStyle: TextStyle(
                                  color: Color(0xff143957),
                                ),
                                helperText: 'Title of document',
                                suffixIcon: Icon(
                                  Icons.check_circle,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff143957)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12  ,
                            ),
/*                          Column(
                              children: [
                                QuillToolbar.basic(controller: _controller),
                                Expanded(
                                  child: Container(
                                    child: QuillEditor.basic(
                                      controller: _controller,
                                      readOnly: false, // true for view only mode
                                    ),
                                  ),
                                )
                              ],
                            )*/

                            TextFormField(
                              controller: contentTF,
                              //keyboardType: TextInputType.multiline,
                              minLines: 7,//Normal textInputField will be displayed
                              maxLines: 20,
                              cursorColor: Theme.of(context).cursorColor,
                              // initialValue: 'type the content of your bloody blog mate',
                              maxLength: 1000,
                              decoration: InputDecoration(
                                labelText: '',
                                helperText: 'Description of your Document',
                                border: OutlineInputBorder(),

                                labelStyle: TextStyle(
                                  color: Color(0xff143957),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (_image != null)?
                            Container(
                              child: Image.file(
                                _image,
                                // width: 100,
                                // height: 100,
                              ),
                            )
                                :
                            Container(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        // bottomSheet: BottomSheet(),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xff143957),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.camera, color: Colors.white,), onPressed: () { _imgFromCamera();}),
              IconButton(icon: Icon(Icons.photo, color: Colors.white,), onPressed: () {  _imgFromGallery();}),
              Spacer(),

            ],
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  _imgFromCamera() async {
    // io.File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50
    // );

    File image;
    PickedFile? pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {
        _image = image;
      });
    }
  }

  _imgFromGallery() async {
    // io.File image = await  ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50
    // );

    File image;
    PickedFile? pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {
        _image = image;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  _uploadMediaFuture(io.File file) {

  }

  Future<void> _CreateWithMediafuture(String title, String content, String mediaId ,String token,BuildContext context) async {

    try{
      setState(() {
        isLoading = true;
      });
      responseClass response = await CreateBlogWithMediaFuture(title, content,mediaId,token);
      setState(() {
        isLoading = false;
      });
      if(response.statuscode==201){
        Fluttertoast.showToast(
            msg: "Blog Created. Post will appear after approval.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      else
      {
        var res = jsonDecode(response.Message);
        Fluttertoast.showToast(
            msg: res["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }

  CreateBlogWithMediaFuture(String title, String content, String mediaId, String token) {}
}

class responseClass{
  responseClass(this.statuscode, this.Message);

  int statuscode;
  String Message;
}