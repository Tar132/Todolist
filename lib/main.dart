import 'package:dejshoppingmall/screens/todolist.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(Myapp());
// }

// //statefull สร้าง  stateless อีกที
// class Myapp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // theme ทำให้ appbar เปลี่ยนสีหน้าใหม่ทุกหน้า
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: Home(),
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList()
    );
  }
}

