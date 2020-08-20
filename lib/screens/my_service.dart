import 'package:dejshoppingmall/widget/add_list_product.dart';
import 'package:dejshoppingmall/widget/show_list_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dejshoppingmall/screens/home.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  //Explicit
  String login = '...';
  Widget currentWidget = ShowListProduct();

  //Method

  @override //ทำเพื่อให้มันทำงานก่อน build โดยไปดึงข้อมูลจาก firebase
  void initState() {
    super.initState();
    findDisplayName();
  }

  Widget showAddList() {
    return ListTile(
      leading: Icon(
        Icons.playlist_add,
        size: 36.0,
        color: Colors.orange,
      ), //leading นำหน้าให้เป็นรูป icon
      title: Text('Add Product'),
      subtitle: Text('Add New Product to Database'),
      onTap: () {
        setState(() {
          currentWidget = AddListProduct();
        });
        Navigator.of(context).pop();//กดแล้วจะหดตัว drawer
      },
    );
  }

  Widget showListProdcut() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36.0,
        color: Colors.orange,
      ),
      title: Text('List Product'),
      subtitle: Text('Show All List Product'),
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth
        .currentUser(); //ดึงdata ของคนlogin ณะขณะนั้นมาที่ firebaseuser
    setState(() {
      login = firebaseUser
          .displayName; // setState เพื่อ ถ้าได้ค่าจาก firenbase แล้วให้ วาด statless ใหม่
      print('login = $login');
    });
  }

  Widget showLoginBy() {
    return Text(
      'Login by $login',
      style: TextStyle(color: Colors.white),
    ); //$เอาค่านั้นมา
  }

  Widget showAppName() {
    return Text(
      'Dej Shopping Mall',
      style: TextStyle(
        color: Colors.red.shade800,
        fontFamily: 'Lobster',
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }

  Widget showLogo() {
    //containner ล้อมรอบไม่ให้เกินขอบ
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        //box decoration ใส่รูปภาพ
        image: DecorationImage(
          image: AssetImage('images/shop.jpg'),
          fit: BoxFit.cover, // boxfit ทำให้รูปภาพเต็มshowhead
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          SizedBox(
            height: 6.0,
          ), //sizebox แก้ ความชิดระหว่าง app name กับ login By
          showLoginBy(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    //buttonDrawer
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          showListProdcut(),
          showAddList(),
        ],
      ),
    );
  }

  Widget signOutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sign Out',
      onPressed: () {
        //ถ้าสิ่งนี้ทำงานจะเรียก method alert
        myAlert();
      },
    );
  }

  Widget cancleButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton() {
    return FlatButton(
      child: Text('Ok'),
      onPressed: () {
        // navigator.pop ปิดปุ่มซะ
        Navigator.of(context).pop();
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are You Sure ?'),
            content: Text('Do You Want Sign Out ?'),
            actions: <Widget>[
              cancleButton(),
              okButton(),
            ],
          );
        });
  }

  @override
  //action <widget> คือเอาปุ่มมาใส่
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: <Widget>[signOutButton()],
        title: Text('My service'),
      ),
      body: currentWidget,
      // show buttonDrawer
      drawer: showDrawer(),
    );
  }
}
