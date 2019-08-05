import 'dart:async';
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';

// ====================================================================
// subscribe to an event
// ====================================================================
Future<Stream<FetchResult>> subscription(
    GraphQLClient client, String subscribe, String operationName) async {
  Operation op = Operation(
    document: subscribe,
    operationName: operationName,
  );

  // ====================================================================
  // dispatch the subscribe rquest
  // ====================================================================
  Stream<FetchResult> result = client.subscribe(op);

  // return the stream
  return result;
}

// ====================================================================
// subscribe TO createUser events
// ====================================================================
Future<Stream<FetchResult>> subscribeUsers(GraphQLClient client) async {
  // ====================================================================
  // subscription operations must be named
  // as required by the graphql package
  // ====================================================================
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

  // ====================================================================
  // activate the subscription
  // name must match the name in the query string
  // ====================================================================
  Stream<FetchResult> stream = await subscription(client, subscribe, 'NewUser');

  // ====================================================================
  // now do something with the subscription
  // in this case just return the stream
  // alternatively this function could parse the emitted events
  // and have a callback parameter
  // ====================================================================

  // return the stream
  return stream;
}
