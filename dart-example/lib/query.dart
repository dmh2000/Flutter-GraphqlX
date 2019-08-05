import 'dart:async';
import 'package:graphql/client.dart';
import 'package:graphql_dart_example/user.dart';

// ====================================================================
// dispatch a query request
// ====================================================================
Future<dynamic> query(GraphQLClient client, String query) async {
  // at minimum, include the query string
  final QueryOptions options = QueryOptions(
    document: query,
  );

  // ====================================================================
  // dispatch the query request
  // ====================================================================
  final QueryResult result = await client.query(options);

  // ====================================================================
  // handle errors by throwing (or return something, your choice)
  // ====================================================================
  if (result.hasErrors) {
    // result.data will have string describing the error
    throw Exception(result.errors[0].message);
  }

  // ====================================================================
  // query result is in result.data which is a map matching the query spec
  // the caller is responsible for parsing the data
  // ====================================================================

  // since this is an async function it wraps the return value in a Future
  return result.data;
}

// =========================================================
// query for a list of users
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

  // ====================================================================
  // the query function throws an exception when a request fails
  // so use try/catch
  // ====================================================================
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
        return User.fromDynamic(u);
      })
      .cast<User>()
      .toList();

  // async functions wrap the return value in a Future
  return users;
}
