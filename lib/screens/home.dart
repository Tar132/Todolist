import 'package:dejshoppingmall/screens/my_service.dart';
import 'package:dejshoppingmall/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dejshoppingmall/screens/authen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Method
  @override
  //ทำงานก่อน build state
  void initState() {
    super.initState();
    checkStatus();
    //login หรือ log out อยู่
  }

  Future<void> checkStatus() async {
    //ขอข้อมูลจาก firebase
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    // ถ้ามีข้อมูลในfirebaseuser จะให้routerไปหน้า my service
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Widget showLogo() {
    //img.asset รูปที่อยู่ในไฟล์ / img.file ตอนถ่ายรูป
    //ใส่ container เพื่อกำหนดขนาดรูปคลิกขวาที่ images wrap container
    return Container(
        width: 120.0, height: 120.0, child: Image.asset('images/logo.png'));
  }

  Widget showAppName() {
    return Text(
      'Tar Shopping Mall',
      style: TextStyle(
          fontSize: 30.0,
          color: Colors.red.shade700,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontFamily: 'Lobster'),
    );
  }

  Widget signInButton() {
    return RaisedButton(
      color: Colors.blue.shade700,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Authen());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget signUpButton() {
    return OutlineButton(
      child: Text('Sign Up'),
      onPressed: () {
        print('you click sign up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButton(),
        SizedBox(
          width: 8.0,
        ),
        signUpButton()
      ],
    );
  }

  @override
  // method build ทำงานเป็นตัวแรก
  Widget build(BuildContext context) {
    return Scaffold(
      //column บนลงล่าง row:ซ้ายไปขวา stack มุมบน
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Colors.yellow.shade800],
            radius: 1.0,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              showAppName(),
              SizedBox(height: 8.0),
              showButton(),
            ],
          ),
        ),
      )),
    );
  }
}
