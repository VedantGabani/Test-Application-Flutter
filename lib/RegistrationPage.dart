import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_application/mainDashboard.dart';
import 'package:test_application/component/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'HomePage.dart';

final _fireStore = Firestore.instance;

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

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
  String name;
  String age;
  bool _showSpinner = false;
  FocusNode _focusNode = new FocusNode();
  List<String> tempList = List();
  bool nameValidator = false;
  bool ageValidator = false;
  bool emailValidator = false;
  bool passWordValidator = false;
  final emailTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  final nameTextFieldController = TextEditingController();
  final ageTextFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

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
                          child: Image.asset('images/register.png', height: 120, width: 120),
                        ),
                      SizedBox(
                        height: 40.0,
                        child: Text('Register Here', textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0, color: Colors.green)),
                      ),
                      TextField(
                            enableInteractiveSelection: false,
                            controller: nameTextFieldController,
                            textAlign: TextAlign.center,
                            onChanged: (value){
                              name = value;
                            },
                          decoration: new InputDecoration(
                            labelText: "Enter Your Name",
                            hintText: "Your Name",
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            errorText: nameValidator ? 'Name Can\'t Be Empty' : null,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                            enableInteractiveSelection: false,
                            controller: ageTextFieldController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value){
                              age = value;
                            },
                          decoration: new InputDecoration(
                            labelText: "Enter Your Age",
                            hintText: "Your Age",
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            errorText: ageValidator ? 'Age Can\'t Be Empty' : null,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                            enableInteractiveSelection: false,
                            controller: emailTextFieldController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
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
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10.0,
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
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Hero(
                        tag: RegistrationScreen.id,
                        child: RoundedButton(
                          colour: Colors.blueAccent,
                          title: 'Register',
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _focusNode.unfocus();
                            if (nameTextFieldController.text.isEmpty) {
                              nameValidator = true;
                              name = null;
                            } else {
                              nameValidator = false;
                            }
                            if (ageTextFieldController.text.isEmpty) {
                              ageValidator = true;
                              age = null;
                            } else {
                              ageValidator = false;
                            }
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
                            setState(() {
                              _showSpinner = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                setState(() {
                                  _showSpinner = false;
                                });
                                _fireStore
                                    .collection('users')
                                    .document('$email')
                                    .setData(
                                        {'name': name, 'age': age});
                                emailTextFieldController.clear();
                                passwordTextFieldController.clear();
                                nameTextFieldController.clear();
                                ageTextFieldController.clear();
                                Navigator.pushNamed(context, MainDashboard.id);
                              }
                            } catch (e) {
                              //if(){}
                              setState(() {
                                _showSpinner = false;
                              });
                              if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                                Toast.show('Email already exists.', context,
                                    duration: 4, gravity: Toast.BOTTOM);
                              } else if (e.code == 'ERROR_WEAK_PASSWORD') {
                                Toast.show(
                                    'Password must be 6 characters long.', context,
                                    duration: 4, gravity: Toast.BOTTOM);
                              } else if (e.code == 'ERROR_INVALID_EMAIL') {
                                Toast.show('Please enter valid Email.', context,
                                    duration: 4, gravity: Toast.BOTTOM);
                              }else if(e.code == 'FirebaseException'){
                                Toast.show('Please check you Internet connection.', context,
                                    duration: 4, gravity: Toast.BOTTOM);
                              } else {
                                Toast.show('Please check your credentials', context,
                                    duration: 4, gravity: Toast.BOTTOM);
                              }
                              print(e);
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
