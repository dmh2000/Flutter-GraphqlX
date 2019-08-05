import 'package:flutter/material.dart';
import 'screens/user_add_screen.dart';
import 'screens/users_screen.dart';
import 'screens/user_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => UserAddScreen(),
          '/show_user': (context) => UserScreen(),
          '/add_user': (context) => UsersScreen(),
        });
  }
}
