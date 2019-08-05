import 'dart:async';
import 'package:graphql/client.dart';
import 'package:graphql_dart_example/user.dart';

// ====================================================================
// dispatch a mutation request
// ====================================================================
Future<dynamic> mutate(GraphQLClient client, String mutation) async {
  final MutationOptions options = MutationOptions(
    document: mutation,
  );

  // ====================================================================
  // disatch the mutate request
  // ====================================================================
  final QueryResult result = await client.mutate(options);

  // ====================================================================
  // handle errors by throwing (or return something, your choice)
  // ====================================================================
  if (result.hasErrors) {
    // result.data will have string describing the error
    throw Exception(result.errors[0].message);
  }

  // ====================================================================
  // query result is in result.data which is a map matching
  // the query spec.
  // the caller is responsible for parsing the data
  // ====================================================================

  // since this is an async function it wraps the return value in a Future
  return result.data;
}

// ====================================================================
// create a user
// ====================================================================
Future<User> createUser(GraphQLClient client, String name, String email) async {
  // ====================================================================
  // this graphql string creates a user and returns the created user object
  // the id is assigned by the graphql server
  // ====================================================================
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
  // ====================================================================
  // the mutate function throws an exception when a request fails
  // ====================================================================
  try {
    // execute a mutation to create a user
    data = await mutate(client, mutation_create_user);
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
    user = User.fromDynamic(data['createUser']);
  } else {
    // return empty user, indicates one was not added
    user = User();
  }

  return user;
}
