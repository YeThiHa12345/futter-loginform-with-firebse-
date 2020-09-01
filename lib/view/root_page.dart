import 'package:firebase_todo/services/authentication.dart';
import 'package:firebase_todo/view/home_page.dart';
import 'package:firebase_todo/view/signin_singup_page.dart';
import 'package:flutter/material.dart';

enum AuthStatus { NOT_DETERMINE, NOT_SIGN_IN, SIGN_IN }

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  const RootPage({this.auth});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINE;
  String userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_SIGN_IN : AuthStatus.SIGN_IN;
      });
    });
  }

  void signinCallback() {
    widget.auth.getCurrentUser().then((value) => setState(() {
          userId = value.uid.toString();
          authStatus = AuthStatus.SIGN_IN;
        }));
  }

  void signOutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_SIGN_IN;
      userId = "";
    });
  }

  Widget waitingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINE:
        return waitingScreen();
        break;
      case AuthStatus.NOT_SIGN_IN:
        return SignInSignUpPage(
          auth: widget.auth,
          signinCallback: signinCallback,
        );
        break;
      case AuthStatus.SIGN_IN:
        if (userId.length > 0 && userId != null) {
          return HomePage(
            auth: widget.auth,
            singoutCallback: signOutCallback,
            userId: userId,
          );
        } else {
          return waitingScreen();
        }
        break;

      default:
        return waitingScreen();
    }
  }
}
