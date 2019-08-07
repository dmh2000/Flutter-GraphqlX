import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../types/user.dart';
import './user_card.dart';

// ======================================================
// here is where the list of users is rendered
// using the result of the graphql provider
// @param users is a List<dynamic>
// ======================================================
Widget userList(context, dynamic users) {
  // no users ?
  if (users.length == 0) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Text('No Users Yet!'),
      ),
    );
  }

  // ===========================================================
  // since 'users' is a list, render it with a ListView.
  // if your data is something else, render it appropriately
  // ===========================================================
  return ListView.builder(
    itemBuilder: (context, index) {
      // ===========================================================
      // do whatever to extract the data from dynamic object
      // see user.dart
      // ===========================================================
      User user = User.fromDynamic(users[index]);
      // ===========================================================
      // render a Card for each user
      // see user_card.dart
      // ===========================================================
      return UserCard(user: user);
    },
    itemCount: users.length,
  );
}

// ===========================================================
// Return a widget that wraps the layout with 'Query'
// ===========================================================
class QueryUsers extends StatelessWidget {
  final String queryUsers = '''
  # query for all users
    query {
      users {
        id
        name
        email
      }
    }
    ''';
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: queryUsers,
      ),
      builder: (QueryResult result, {VoidCallback refetch}) {
        // ========================================================
        // HANDLE ERRORS
        // ========================================================
        if (result.errors != null) {
          return Text(result.errors.toString());
        }

        // ========================================================
        // LOADING
        // ========================================================
        if (result.loading) {
          return Container(child: CircularProgressIndicator());
        }

        // ========================================================
        // DATA READY
        // 'result' contains the data. you have to interpret
        // however the graphql server returns it. in this
        // case the result.data is a map with a single
        // property 'users', which in turn is a dynamic list
        // ========================================================
        return userList(context, result.data['users']);
      },
    );
  }
}

// ========================================================
// this shows the list of users. this is mostly layout
// and can be mostly ignored regarding the graphql usage
// the work is done in the QueryUsers function above
// ========================================================
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ===========================================================
    // no need for an '.of' or whatever to access the provider
    // that's handled internally by the Query object
    // ===========================================================
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                // =========================================
                // QUERY FOR USERS
                // =========================================
                child: QueryUsers(),
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
              currentIndex: 0,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/add_user');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/subscription');
                    break;
                }
              }),
        ));
  }
}
