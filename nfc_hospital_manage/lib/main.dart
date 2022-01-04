import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nfc_hospital_manage/page/UserselectionPage.dart';
import 'package:nfc_hospital_manage/widgets/notification.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';





Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
/*  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
      appId: '1:448618578101:ios:2bc5c1fe2ec336f8ac3efc',
      messagingSenderId: '448618578101',
      projectId: 'react-native-firebase-testing',
    ),
  );*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _initialized = false;
  bool _error = false;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      final firebaseMessaging = FCM();
      firebaseMessaging.setNotifications();

      firebaseMessaging.streamCtlr.stream.listen(_changeData);
      firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
      firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();




    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {

    if(_error) {
      return AlertDialog(
        title: Text("Error"),
      );
    }
    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return AlertDialog(
        title: Text("Loading"),
      );
    }

    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds: new UserselectionPage(),
      title: new Text(
        '',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset("images/N-Mark_blue_TM.jpg",fit:  BoxFit.fill,colorBlendMode: BlendMode.srcOver,filterQuality:FilterQuality.low ,),
      photoSize: 100,
     gradientBackground:  LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white,Colors.white,Colors.white ,Colors.lightBlueAccent,Colors.blue]),
     // backgroundColor: Colors.white,
      useLoader: true,
      loaderColor: Colors.greenAccent,
    );
  }
}


