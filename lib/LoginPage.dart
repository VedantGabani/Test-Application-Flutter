import 'package:test_application/mainDashboard.dart';
import 'package:test_application/component/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'HomePage.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

    Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Center(child: Text('Are you sure?')),
        content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : <Widget>[
                Expanded(
                  child: Text(
                    'Do you want to go back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
            textColor: Colors.green,
          ),
          new FlatButton(
            onPressed: () => Navigator.popAndPushNamed(context, WelcomeScreen.id),
            child: new Text('Yes'),
            textColor: Colors.green,
          ),
        ],
      ),
    ) ?? false;
  }

  String email;
  String password;
  bool emailValidator = false;
  bool passWordValidator = false;
  bool _showSpinner = false;
  final emailTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FocusNode _focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                    Container(
                      height: 200.0,
                      child: Image.asset('images/login.png', height: 120, width: 120),
                    ),
                    SizedBox(
                      height: 60.0,
                      child: Text('Login Here', textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0, color: Colors.green)),
                    ),
                    TextField(
                      enableInteractiveSelection: false,
                      controller: emailTextFieldController,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _focusNode,
                      textAlign: TextAlign.center,
                      onChanged: (value){
                        email = value;
                      },
                      decoration: new InputDecoration(
                        labelText: "Enter Your Email",
                        hintText: "Your Email",
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        errorText: emailValidator ? 'Email Can\'t Be Empty' : null,
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      enableInteractiveSelection: false,
                      controller: passwordTextFieldController,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value){
                        password = value;
                      },
                      decoration: new InputDecoration(
                        labelText: "Enter Your Password",
                        hintText: "Your Password",
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        errorText: passWordValidator ? 'Password Can\'t Be Empty' : null,
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Hero(
                      tag: LoginScreen.id,
                      child: RoundedButton(
                        colour: Colors.lightBlueAccent,
                        title: 'Log In',
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _focusNode.unfocus();
                          setState(() {
                            if (emailTextFieldController.text.isEmpty) {
                              emailValidator = true;
                              email = null;
                            } else {
                              emailValidator = false;
                            }
                            if (passwordTextFieldController.text.isEmpty) {
                              passWordValidator = true;
                              password = null;
                            } else {
                              passWordValidator = false;
                            }
                          });
                          setState(() {
                            _showSpinner = true;
                          });
                          try {
                            final loggedInUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (loggedInUser != null) {
                              setState(() {
                                _showSpinner = false;
                              });
                              emailTextFieldController.clear();
                              passwordTextFieldController.clear();
                              Navigator.popAndPushNamed(context, MainDashboard.id);
                              email = null;
                              password = null;
                            }
                          } catch (e) {
                            setState(() {
                              _showSpinner = false;
                            });
                            if (e.code == 'ERROR_INVALID_EMAIL') {
                              Toast.show('Please enter valid Email.', context,
                                  duration: 4, gravity: Toast.BOTTOM);
                            } else if (e.code == 'ERROR_USER_NOT_FOUND') {
                              Toast.show('User not found.', context,
                                  duration: 4, gravity: Toast.BOTTOM);
                            }else if(e.code == 'FirebaseException'){
                              Toast.show('Please check you Internet connection.', context,
                                  duration: 4, gravity: Toast.BOTTOM);
                            }else {
                              Toast.show('Please check your credentials.', context,
                                  duration: 4, gravity: Toast.BOTTOM);
                            }
                            print(e);
                            // print(e.code);
                            // print(e.message);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
