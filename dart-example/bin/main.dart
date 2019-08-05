import 'dart:async';
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';

// user type
class User {
  final String name;
  final String email;
  final String id;

  // default constructor with init parameters
  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromDynamic(data) {
    String id = data['id'];
    String name = data['name'];
    String email = data['email'];
    return User(id: id, name: name, email: email);
  }

  String toString() {
    return 'id:$id, name:$name, email:$email';
  }
}

/// execute a query
/// @param client GraphqlClient
/// @param query String the graphql query string
/// @return Future<dynamic>  - either a list of map depending on the query type
/// @return null - if query has errors
/// the caller needs to know what to expect
///
Future<dynamic> query(GraphQLClient client, String query) async {
  // at minimum, include the query string
  final QueryOptions options = QueryOptions(
    document: query,
  );

  // call the graphql server
  final QueryResult result = await client.query(options);

  // handle errors by throwing (or return something, your choice)
  if (result.hasErrors) {
    // result.data will have string describing the error
    throw Exception(result.errors[0].message);
  }

  // query result is in result.data which is a map matching the query spec
  // the caller needs to know what to expect
  // since this is an async function it wraps the return value in a Future
  return result.data;
}

/// execute a mutation
/// @param client GraphqlClient
/// @param mutation String the graphql mutation string
/// @return Future<dynamic>  - either a list of map depending on the query type
/// @return null - if query has errors
/// the caller needs to know what to expect
///
Future<dynamic> mutation(GraphQLClient client, String mutation) async {
  final MutationOptions options = MutationOptions(
    document: mutation,
  );

  // call the graphql server
  final QueryResult result = await client.mutate(options);

  // handle errors by throwing (or return something, your choice)
  if (result.hasErrors) {
    // result.data will have string describing the error
    throw Exception(result.errors[0].message);
  }

  // query result is in result.data which is a map matching the query spec
  // the caller needs to know what to expect
  // since this is an async function it wraps the return value in a Future
  return result.data;
}

/// subscribe to an event
/// @param client
/// @param subscribe - graphql subscription string
/// @return Future<Stream<FetchResult>>
Future<Stream<FetchResult>> subscription(
    GraphQLClient client, String subscribe, String operationName) async {
  Operation op = Operation(
    document: subscribe,
    operationName: operationName,
  );

  // issue the subscribe rquest
  Stream<FetchResult> result = client.subscribe(op);

  // return the stream
  return result;
}

// =========================================================
/// SUBSCRIBE TO createUser events
// =========================================================
Future<Stream<FetchResult>> subscribeUsers(GraphQLClient client) async {
  // subscription operations must be named, required by the graphql package
  String subscribe = r'''
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

  // wait for subscription to be active
  Stream<FetchResult> stream = await subscription(client, subscribe, 'NewUser');

  // return the stream
  return stream;
}

// =========================================================
/// QUERY FOR A LIST OF ALL USERS
// =========================================================
Future<List<User>> getUsers(GraphQLClient client) async {
  const String query_users = r'''
  query {
    users {
      id
      name
      email
    }
  }
  ''';

  // this code has the graphql request throw an exception when a request fails
  // so use try/catch
  dynamic data;
  try {
    // execute a query to get all users
    data = await query(client, query_users);
  } catch (e) {
    // print error String
    print(e.toString());

    // return empty list
    data = null;
  }

  // ====================================================================
  // query is over at this point, do something with the return data
  // data['users'] is a List<Map<String,String>>
  // ====================================================================

  if (data == null) {
    // return an empty list
    return List<User>();
  }

  // convert to list of User objects
  List<User> users = data['users']
      .map((u) {
        // extract value from map and create a user object
        // String id = u['id'];
        // String name = u['name'];
        // String email = u['email'];
        // var user = User(id: id, name: name, email: email);
        // return user;
        return User.fromDynamic(data);
      })
      .cast<User>()
      .toList();

  // async functions wrap the return value in a Future
  return users;
}

/// CREATE A USER
Future<User> createUser(GraphQLClient client, String name, String email) async {
  // this graphql string creates a user and returns the created user object
  // the id is assigned by the graphql server
  final String mutation_create_user = '''
  mutation {
    createUser(data: { name: "$name", email: "$email"}) {
      id
      name
      email
    }
  }
  ''';

  dynamic data;
  User user;
  // this code has the graphql request throw an exception when a request fails
  // so use try/catch
  try {
    // execute a mutation to create a user
    data = await mutation(client, mutation_create_user);
  } catch (e) {
    // print error String
    print(e.toString());

    // return empty user
    data = null;
  }

  // ====================================================================
  // at this point data['createUser'] is a map containing the fields
  // do something with it. in this case convert it to a User object
  // ====================================================================
  if (data != null) {
    user = User(
      id: data['createUser']['id'],
      name: data['createUser']['name'],
      email: data['createUser']['email'],
    );
  } else {
    // return empty user, indicates one was not added
    user = User();
  }

  return user;
}

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
  final WebSocketLink link = WebSocketLink(url: 'ws://localhost:4000');

  final GraphQLClient client = GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );

  // subscribe to user creation and wait on returned stream
  Stream<FetchResult> stream = await subscribeUsers(client);

  stream.listen(
    (FetchResult fr) {},
    onError: (e) {
      print(e.toString());
    },
    onDone: () {
      print('done)');
    },
    cancelOnError: false,
  );

  // create 4 users (note: if you repeat this without restarting server it will complain about duplicate email)
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
  List<User> users = await getUsers(client);
  users.forEach((u) {
    print('getUsers: $u');
  });

  // issue an invalid query to get exception
  await queryWithError(client);

  // keep event loop going
  int count = 0;
  Timer.periodic(Duration(seconds: 10), (t) {
    print('${count++}');
  });
}
