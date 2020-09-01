import 'package:firebase_todo/services/authentication.dart';
import 'package:flutter/material.dart';

class SignInSignUpPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback signinCallback;

  SignInSignUpPage({this.auth, this.signinCallback});
  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final formKey = GlobalKey<FormState>();

  bool _isLoading;
  bool _isSigninForm;

  String _email;
  String _password;
  String _errormessage;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errormessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isSigninForm) {
          userId = await widget.auth.singIn(_email, _password);
        } else {
          userId = await widget.auth.singUp(_email, _password);
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isSigninForm == true) {
          widget.signinCallback();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errormessage = e.message;
          formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errormessage = "";
    _isLoading = false;
    _isSigninForm = true;
    super.initState();
  }

  void resetForm() {
    formKey.currentState.reset();
    _errormessage = "";
  }

  void toggleForm() {
    resetForm();
    setState(() {
      _isSigninForm = !_isSigninForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutte ToDo"),
      ),
      body: Stack(
        children: [showCircularPrograss(), showForm()],
      ),
    );
  }

  Widget showForm() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
          key: formKey,
          child: ListView(
            children: [
              showEmailInput(),
              showPassowrdInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage()
            ],
          )),
    );
  }

  Widget showCircularPrograss() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget showErrorMessage() {
    if (_errormessage.length > 0 && _errormessage != null) {
      return Text(
        _errormessage,
        style: TextStyle(color: Colors.red, fontSize: 12),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.email,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPassowrdInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Passowrd can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        onPressed: validateAndSubmit,
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.blue,
        child: Text(
          _isSigninForm ? 'SignIn' : 'Create account',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
        onPressed: toggleForm,
        child: Text(
          _isSigninForm ? 'Create account' : 'Sign In',
          style: TextStyle(fontSize: 18),
        ));
  }
}
