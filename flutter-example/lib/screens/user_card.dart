import 'package:flutter/material.dart';
import '../types/user.dart';

// ============================================================
// this is just a simple card widget fto display user data
// it doesn't have anything to do with the Graphql operations
// ============================================================
class UserCard extends StatelessWidget {
  final User user;

  UserCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text('${user.name}'),
              Text('${user.email}'),
              Text('${user.id}'),
            ],
          ),
        ),
      ),
    );
  }
}
