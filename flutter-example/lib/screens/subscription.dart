import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../types/user.dart';
import './user_card.dart';

class UserScreen extends StatelessWidget {
  Widget subscription(context) {
    String subscribe = '''
    subscription NewUser {
    user {
      data {
        id
        name
        email
      }
    }
  }
  ''';

    return Subscription('NewUser', subscribe, builder: ({
      bool loading,
      dynamic payload,
      dynamic error,
    }) {
      // ======================================
      // first handle errors
      // ======================================
      if (error != null) {
        return Text('$error');
      }

      // ======================================
      // second handle no payload yet
      // ======================================
      if (payload == null) {
        return Text('waiting');
      }

      // ================================================================================
      // payload has data, extract and show it
      // payload is a map and its data is determined by what the subscription returns
      // in this case it returns a user payload with a data member that has the details
      // ================================================================================
      User user = User.fromDynamic(payload['user']['data']);
      return UserCard(user: user);
    });
  }

  final String heading = '''
  This shows when a user is created somewhere else
  Create one at playground  http://localhost:4000
  Here's the mutation string to use
  mutation createUser {
    createUser(
      data: { name: "name", email: "email@email.com" })
      {
      id
      name
      email
    }
  }''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(heading),
            Divider(),
            Center(
              child: Container(
                // ============================================================
                // the subscription widget (see function subscription() above
                // this is the important part for the Graphql stuff
                // ============================================================
                child: subscription(context),
              ),
            ),
          ],
        ),
      ),
      // the following is just navigation, not relevant to graphql code

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
