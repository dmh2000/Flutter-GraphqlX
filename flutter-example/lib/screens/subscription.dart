import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // display the users
            Text('Subscription')
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Show Users'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Add user'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Subscription'),
            ),
          ],
          currentIndex: 2,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/');
                break;
              case 1:
                Navigator.pushNamed(context, '/add_user');
                break;
              case 2:
                break;
            }
          },
        ),
      ),
    );
  }
}
