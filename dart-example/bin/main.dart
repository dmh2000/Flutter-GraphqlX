import 'dart:async';
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';
import 'package:graphql_dart_example/user.dart';
import 'package:graphql_dart_example/subscribe.dart';
import 'package:graphql_dart_example/mutate.dart';
import 'package:graphql_dart_example/query.dart';

void queryWithError(GraphQLClient client) async {
  const String query_error = r'''
    query {
      userx {
        id
        name
        email
      }
    }
    ''';

  // return values are dynamic
  dynamic data;

  // this code has the graphql request throw an exception when a request fails
  // so use try/catch
  try {
    // execute a query that fails
    data = await query(client, query_error);
    print(data);
  } catch (e) {
    // print error String
    print(e.toString());
  }
}

void main() async {
  // WebSocketLink is required if using subscriptions!
  // otherwise HttpLink is ok
  final WebSocketLink link = WebSocketLink(url: 'ws://localhost:4000');

  // create the client
  final GraphQLClient client = GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );

  // subscribe to user creation with callback
  // SEE lib/subscribe.dart
  Stream<FetchResult> stream = await subscribeUsers(client);

  // listen for subscription events
  stream.listen(
    (FetchResult fr) {
      User user = User.fromDynamic(fr.data['user']['data']);
      print('subscribeUsers : $user');
    },
    onDone: () {
      print('done');
    },
    onError: (e) {
      print(e.toString());
    },
  );

  // create 4 users
  // SEE lib/mutate.dart
  // (note: if you repeat this without restarting server it will complain about duplicate email)
  User user;
  user = await createUser(client, 'Fred', 'Fred@example.com');
  print('createUser : $user');
  user = await createUser(client, 'Mary', 'Mary@example.com');
  print('createUser : $user');
  user = await createUser(client, 'John', 'John@example.com');
  print('createUser : $user');
  user = await createUser(client, 'Zoey', 'Zoey@example.com');
  print('createUser : $user');

  // query for  a list of all users and print it
  // SEE lib/query.dart
  List<User> users = await getUsers(client);
  users.forEach((u) {
    print('getUsers: $u');
  });

  // issue an invalid query to get exception
  await queryWithError(client);
}
