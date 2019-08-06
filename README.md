# GraphqlX - Simple Examples of using GraphQL with Dart and Flutter

This is the second article in a planned series of SIMPLE examples of certain Flutter packages. I mean simple, because I am not that smart and I like to see simple examples. Sometimes software examples are more complex than they need to be. 

This article describes and provides working code for two examples of using GraphQl, one for Dart cli and one for 
Flutter apps. The intent here is not a tutorial about Graphql. You probably want to be familiar with it before going further. 

The packages used here were created by the engineers at [Zino App BV](https://www.zinoapp.com/). They provide two packages :

  - [graphql](https://pub.dev/packages/graphql) for standalone dart applications. see 'dart-example';
  - [graphql_flutter](https://pub.dev/packages/graphql_flutter) for flutter apps. see 'flutter-example';
   
These two packages used Apollo client as inspiration so anyone used to Apollo will probably feel at home. 

## A Graphql server

These packages are client side packages so you need a graphql server to test against. The 'server' directory has a very simple (again) graphql server written for node.js using the [graphql_yoga](https://github.com/prisma/graphql-yoga) framework. 

To run the server, you need node.js (v8 or later) installed. then cd into 'server', run 'npm install', then 'npm start'. If you point your browser at http://localhost:4000 you will get an instance of Graphql Playground to test against. That url is also the endpoint for client access. 

### Schema

Graphql of course requires a schema. The schema contains a single 'Users' datastore with queries for finding and listing users, a mutation for adding a user, and a subscription to add users events. The datastore is a local array of Users.
The schema definition is in server/src/schema.graphql. 
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

## PART 1 : dart-example

This is about building a Dart CLI app using the package [graphql](https://pub.dev/packages/graphql). 

The graphql (dart) package provides functions and objects that support GraphQL clients making query, mutation and 
subscription requests. 

See [README dart-example](dart-example/README.md) for its documentation.

## Coming Soon : flutter-example
This is about building a Flutter app using the package [graphql_flutter](https://pub.dev/packages/graphql_flutter). 

The graphql_flutter package provides Widgets that support integration of Graphql queries, mutations and subscriptions into a Flutter app. I found it pretty easy to use. 

See [README flutter-example](flutter-example/README.md) for its documentation.
