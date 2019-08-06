# GrapQL with Dart

This article is about using [graphql](https://pub.dev/packages/graphql) for standalone dart applications, or alternatively, 
using it for a Flutter application where you want to go lower level and not use the 
[graphql_flutter](https://pub.dev/packages/graphql_flutter) package.  The example program here is a Dart CLI program. 

## A Graphql server

See the top level [README.md](../README.md) has instructions on  running the graphql server that is included in this repo.

## Schema

Here is the schema that the server implements;

```graphql

  # query for one or all users
  type Query {
    user(id: ID): User  
    users: [User!]! 
  }

  # create and delete a user
  type Mutation {
    createUser(data: CreateUserInput): User!
    deleteUser(id: ID!): User!
  }

  # subscribe to createUser events
  type Subscription {
    user: UserSubscriptionPayload 
  }

  # data required to create a user
  input CreateUserInput {
    name: String!
    email: String!
  }

  # definition of a User
  type User {
    id: ID!
    name: String!
    email: String!
  }

  # definition of the subscription return data
  type UserSubscriptionPayload {
    data: User!
  }
```

## Dart Application 

The main function is in bin/main.dart. It does the following:

- creates the graphql client with a WebSocketLink(required for subscriptions). The alternative is an HttpLink if the app doesn't need subscriptions.
- subscribes to createUser events and listens for them
- creates four users and prints the results. the subscription events should fire also and print something.
- queries for a list of users then prints them
- issues an erroneous query to test error handling.

The rest of the code is in lib. It is structured in separate files each containing one of the concerns.

### [user.dart](../lib/user.dart)

Contains a definition of the user type and its constructors.

### [query.dart](../lib/query.dart)

Contains a function to dispatch a generic query, and one that dispatches the specific query for a list of users.

### [mutate.dart](../lib/mutate.dart)

Contains a function to dispatch a generic mutation, and one that dispatches the specific 'createUser' operation.

### [subscribe.dart](../lib/subscribe.dart)

Contains a function to dispatch a generic subscription request and one that dispatches the subscription to listen for crated users.

## Running the code

  - Have Dart installed in the command line path.
  - cd info dart-example
  - get dependencies with 'pub get'
  - run the program '>dart bin/main.dart

