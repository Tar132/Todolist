import 'package:dejshoppingmall/screens/my_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//containerที่ใส่ widget ได้หลายตัวมี  4ตัว coloumnบนลงล่าง, rowซ้ายไปขวา, listviewจะเหมือนcolumnแต่ใส่เกินจอได้รูดครึ่งรูดลง ,Stackใส่ widget ได้มากกว่า 1ตัว แต่อยู่มุมซ้ายบนเสมอ
class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  //Explicit
  // formkey รับค่า email กับ pw ไปประมวลผล
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString;

  //Method

  Widget backButton() {
    return IconButton(
      //.navigate_before ลูกศรย้อนกลับ
      icon: Icon(
        Icons.navigate_before,
        size: 30.0,
        color: Colors.red.shade800,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget content() {
    //บนลงล่าง
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showAppName(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }

  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showLogo(),
        showText(),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 48.0,
      height: 48.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showText() {
    return Text('Dej Shopping Mall',
        style: TextStyle(
            fontSize: 22.0,
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Lobster'));
  }

  Widget emailText() {
    return Container(
      width: 300.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 36.0,
            color: Colors.red.shade800,
          ),
          labelText: 'Email: ',
          labelStyle: TextStyle(color: Colors.red.shade800),
        ),
        onSaved: (String value) {
          emailString = value.trim();
          //เซ็ทค่า string จาก keyboard
          //trimตัดช่องว่างออก
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 300.0,
      //obsuctext true ทำให้เป็น star***
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, size: 36.0, color: Colors.red.shade800),
          labelText: 'Password: ',
          labelStyle: TextStyle(
            color: Colors.red.shade800,
          ),
        ),
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // await เช็คว่ามี email pw ใน firebaseไหมถ้ามีเด้งไปอีกหน้า
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Authen Success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget okButton() {
    return FlatButton(
      child: Text('Ok'),
      onPressed: () {Navigator.of(context).pop();},
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(title),
            content: Text(message),
            actions: <Widget>[okButton(),],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Colors.white, Colors.yellow.shade800], radius: 1.0)),
          child: Stack(
            children: <Widget>[
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade800,
        child: Icon(
          Icons.navigate_next,
          size: 36.0,
        ),
        onPressed: () {
          formKey.currentState.save();
          print('email = $emailString, password = $passwordString');
          //เมื่อไรได้ข้อมูลจาก stringแล้วให้ทำการcheckauthen();จาก firebase
          checkAuthen();
        },
      ),
    );
  }
}
