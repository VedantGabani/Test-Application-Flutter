import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:test_application/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:test_application/component/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;

class MainDashboard extends StatefulWidget {
  static String id = 'mainDashboard';
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  var name;
  var age;
  var data;

  void getData()async {
    _showSpinner = true;
    var fireBaseUserId = await _auth.currentUser();
    data = await _fireStore
        .collection('users')
        .document('${fireBaseUserId.email}')
        .get();

    setState(() {
      _showSpinner = false;
      name = data['name'];
      age = data['age'];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
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
                    'Do you want to Logout',
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
            onPressed: () {
              Navigator.popAndPushNamed(context, LoginScreen.id);
              _auth.signOut();
            },
            child: new Text('Yes'),
            textColor: Colors.green,
          ),
        ],
      ),
    ) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.popAndPushNamed(context, LoginScreen.id);
              _auth.signOut();
            },
          )
        ],
        title: Text('Demo Application'),
        backgroundColor: Colors.grey,
      ),
      body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimatedTextKit(
                        text: ["User Details"],
                        textStyle: TextStyle(fontSize: 25.0, color: Colors.green),
                        alignment: AlignmentDirectional.topStart,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Name : $name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                              ),  
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              'Age : $age',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                              ),  
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: RoundedButton(
                            colour: Colors.lightBlueAccent,
                            title: 'Sign Out',
                            onPressed: () {
                              Navigator.popAndPushNamed(context, LoginScreen.id);
                              _auth.signOut();
                            },
                            textSize: 17.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}