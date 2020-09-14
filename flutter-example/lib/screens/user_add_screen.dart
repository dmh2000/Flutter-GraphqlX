import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../types/user.dart';
import './user_card.dart';

// =====================================================
// the action is in the function 'mutation' below
// thats where the mutation is handled. everything
// else is just scaffolding and styling
// =====================================================

// =====================================================
// a stateful widget is used here to capture user input
// =====================================================
class UserAddScreen extends StatefulWidget {
  @override
  _UserAddScreenState createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  String userName = '';
  String userEmail = '';

  // ==============================================================
  // some of the construction of the various widgets for this screen
  // are extracted into functions to make things a bit more readable
  // ==============================================================

  // =====================================================
  // this widget is shown when the mutation has not
  // yet been run (data == null) or (loading == true)
  // =====================================================
  Widget mutationInput(context, runMutation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // a basic text field for user name input
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User Name',
            hintText: 'name',
          ),
          onChanged: (String t) {
            userName = t;
          },
        ),
        SizedBox(height: 20.0),
        // a basic text field for user email input
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User Email',
            hintText: 'email',
          ),
          onChanged: (String t) {
            userEmail = t;
          },
        ),
        SizedBox(height: 20.0),
        FloatingActionButton(
          // =====================================================
          // runMutation gets a map that is used to fill in the
          // mutation parameters in the mutation string.
          // =====================================================
          onPressed: () => runMutation(
            {
              'name': userName, // data from the text field
              'email': userEmail, // data from the text field
            },
          ),
          tooltip: 'Add User',
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  // ==============================================================
  // this widget shows a progress indicator while the mutation
  // is in progress. such as a long'ish network roundtrip
  // ==============================================================
  Widget mutationLoading() {
    return Container(
      child: CircularProgressIndicator(),
    );
  }

  // ==============================================================
  // this widget shows the user data when the mutation has executed
  // ==============================================================
  Widget mutationDone(context, result) {
    User user = User.fromDynamic(result.data['createUser']);
    return Column(
      children: <Widget>[
        Text('User was Added'),
        SizedBox(
          height: 20.0,
        ),
        UserCard(user: user),
      ],
    );
  }

  // =====================================================
  // This function renders the graphql_flutter Mutation
  // this is where the action is
  // =====================================================
  Widget mutation(context) {
    // =====================================================
    // create the mutation string
    // the parameters should be escaped as they are filled
    // in later by the runMutation function
    // =====================================================
    String createUser = '''
    mutation createUser(\$name: String!, \$email : String!) {
      createUser(data: { name: \$name, email: \$email }) {
        id
        name
        email
        }
    }
    ''';

    return Mutation(
      // =====================================================
      // specify the mutation document (the string above)
      // =====================================================
      options: MutationOptions(
        document: createUser, // mutation string
      ),
      builder: (
        RunMutation runMutation, // this is provided by Flutter Graphql
        QueryResult result, // this is provided by Flutter Graphql
      ) {
        // =======================================
        // first, handle any errors
        // =======================================
        if (result.hasException) {
          return Text('${result.exception}');
        }

        // =======================================
        // do something while it is loading
        // =======================================
        if (result.loading) {
          return mutationLoading();
        }

        // =====================================================================
        // if result.data is null here the mutation has not been dispatched
        // so show the text input widget.
        //
        // the runMutation function, provided by the Mutation builder
        // is passed to the mutation input function. that's just so I
        // could move the input code to a separate function
        // =====================================================================
        if (result.data == null) {
          return mutationInput(context, runMutation);
        }

        // =====================================================================
        // the mutation has been completed, do something with the result data
        // =====================================================================
        return mutationDone(context, result);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(10),
        // =====================================================
        // the mutation widget (see function mutation() above
        // this is the important part for the Graphql stuff
        // =====================================================
        child: mutation(context),
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
          currentIndex: 1,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/');
                break;
              case 1:
                break;
              case 2:
                Navigator.pushNamed(context, '/subscription');
                break;
            }
          },
        ),
      ),
    );
  }
}
