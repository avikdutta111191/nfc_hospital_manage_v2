import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:nfc_hospital_manage/page/Doctor/D_homePage.dart';
import 'package:nfc_hospital_manage/page/Reception/R_HomePage.dart';
import 'package:nfc_hospital_manage/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class DoctorLogin extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);



  late User user_;

  Future<void> addUser(LoginData data) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'email': data.name, // John Doe
      'password': data.password, // Stokes and Sons
      'type': 'doctor'

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addDoctors(LoginData data) {
    CollectionReference users = FirebaseFirestore.instance.collection('doctor');

    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'email': data.name, // John Doe
      'password': data.password, // Stokes and Sons
      'type': 'doctor',
      'fname':'Please add first name',
      'mname':'Please add middle name',
      'lname':'Please add last name',
      'phone':'Please add phone',
      'address':'Please add address',

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<String?> _signUpUserF(LoginData data) async {

    try {
      UserCredential userCredential  = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name,
          password: data.password
      );
      print("eee"+userCredential.user!.email.toString());
      user_=userCredential.user!;
      addUser(data);
      addDoctors(data);



    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return e.message;

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return e.message;

      }
      else if(e.code == 'user-not-found'){
        print(e.message);
        return e.message;

      }
      else{
        print(e.message);

        return e.message;

      }
    } catch (e) {
      print(e);
    }


    return null;

  }



  Future<String?> _loginUserF(LoginData data) async {

    try {
      var userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name,
          password: data.password
      );
      print("eee"+userCredential.user!.email.toString());
      user_=userCredential.user!;
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return e.message;

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return e.message;

      }
      else if(e.code == 'user-not-found'){
        print(e.message);
        return e.message;

      }
      else{
        print(e.message);

        return e.message;

      }
    } catch (e) {
      print(e);
    }




    return null;

  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }



  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Login as Doctor',
      logo: 'images/doctor.png',
      loginAfterSignUp: true,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot huh?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
        flushbarTitleError: 'Oh no!',
        flushbarTitleSuccess: 'Succes!',
      ),
      theme: LoginTheme(
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.amber,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.deepPurpleAccent,
        pageColorDark: Colors.blue,
        titleStyle: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Quicksand',
            //letterSpacing: 4,
            fontSize: 18,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold
        ),
      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUserF(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');

        return _signUpUserF(loginData);
      },


      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => D_HomePage(title: 'Doctors Desk',user_: user_),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}