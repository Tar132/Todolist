import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dejshoppingmall/screens/my_service.dart';

//ตอนที่19 override statefulwidget แล้วลบ container
//ตอนที่20 appbar ตอนที่21 widget name ตอนที่23 validator ต้องใส่ชื่อยังไง, formkey คือเอาค่ามาจาก keyboard

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString;

  //Method
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('you clikc upload');
        // if.validate คือต้องกรอกข้อมูลจนครบทั้งหมด state ถึงจะเป็น true แล้วจะทำการsave
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'name = $nameString, email = $emailString, pw =$passwordString');
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread() async {
    //ดึงข้อมูลจาก firebase
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register Success for Email = $emailString');
      setUpDisplayname();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setUpDisplayname() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);
      //material ไปยังอีกหน้าสร้างหน้าใหม่ทับ
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 40.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(
        color: Colors.purple,
      ),
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.purple,
          size: 48.0,
        ),
        labelText: 'Display Name :',
        labelStyle: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        helperText: 'Type Your Nick Name for Display',
        helperStyle: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        //ตัดช่องว่างหน้าและหลังคำของ name
        nameString = value.trim();
      },
    );
  }


  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.green.shade800,
      ),
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.green.shade800,
          size: 48.0,
        ),
        labelText: 'Email :',
        labelStyle: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        helperText: 'Type Your Email',
        helperStyle: TextStyle(
          color: Colors.green.shade800,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        //value.contains เข็คตรง email ว่ามี "@" ไหม ส่วนใส่ ! แปลว่าถ้ามันไม่มี
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please Type Email in Exp.you@email.com';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      style: TextStyle(
        color: Colors.blue.shade800,
      ),
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.blue.shade800,
          size: 48.0,
        ),
        labelText: 'Password :',
        labelStyle: TextStyle(
          color: Colors.blue.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        helperText: 'Type Your Password more 6 characters ',
        helperStyle: TextStyle(
          color: Colors.blue.shade800,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'Password More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: Text('Register'),
        actions: <Widget>[registerButton()],
      ),
      //padding ทำให้ listview ห่างกัน
      //ListView คือ viewGroup ที่ทำการล้อมรอบ name email password
      body: Form(
        key: formKey,
        child: Container(decoration: BoxDecoration(gradient: RadialGradient(colors:[Colors.white,Colors.yellow.shade800],radius: 1.0)),
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: <Widget>[
              nameText(),
              emailText(),
              passwordText(),
            ],
          ),
        ),
      ),
    );
  }
}
