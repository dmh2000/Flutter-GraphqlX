# GraphQL with Flutter

This article is about using the [graphql_flutter](https://pub.dev/packages/graphql_flutter) package in a Flutter
appllication. There is also an example of using the [graphql](https://pub.dev/packages/graphql) package for standalone dart applications in [Dart Example](../dart-example/README.md).

The intent here is to provide very simple working code that contains examples of how to use a query, a mutation and a subscription in a Flutter application. The UI for this example is a bit rough, it isn't intended to show how to best structure and style a Flutter app. It is intentionally simple to avoid having UI issues obscuring the graphql code.

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

## Flutter App

The main function is in lib/main.dart. It does the following: 


- creates the graphql client with a WebSocketLink(required for subscriptions). The alternative is an HttpLink if the app doesn't need subscriptions. A WebSocketLink works for all operations, but a difference is that the WebSocketLink holds a connection open and will reconnect to the server if the connection is lost. If you don't need to subscribe and you don't want the app holding a persistent connection then user HttpLink which supports queries and mutations.
- starts a MaterialApp with 3 screens
- see the note about subscriptions, SocketClient and WebSocketLink below.


### lib/screens/users_screen.dart

A screen showing all the Users in the server database. It uses a Query widget to fetch the list of 
users from the server database. After a server restart there will be no Users in the database
so go the Add User screen to add one or more.

### lib/screens/user_add_screen.dart

A screen to create a user and add it to the server database. It uses a Mutation widget to add a user to 
the server database. Enter a name and email, then click +. if the mutation succeeds, the new
user data will be shown. If you navigate back to the Users screen, the new user should show
up in the list.

### lib/subscription.dart

The flutter_graphql API docs warm that handling subscriptions is experimental for now. The code 
included here works for version 2.0.1 but if the API changes it might break. Although the
current documentation says to create a global SocketClient object for subscriptions to work,
I found that they seem to work if the top level 'Link' object is a WebSocketLink. That may change
in the future. 

This is a screen that subscribes to user creation events so you can monitor users created somewhere else. It
uses a Subscription widget that will show one User whenever a new one is added. The subscription
is active only when this screen is up, so whever you navigate to it, it won't show a user event
until a new user is created. Use the Graphql Playground at localhost:4000 to create users. The new
users shoudl show up on the subscription screen. 
Use this mutation string at the playground:

 mutation createUser {
    createUser(
      data: { name: "name", email: "email@email.com" })
      {
      id
      name
      email
    }
  }

### lib/user.dart

Contains a definition of the **User** type and its constructors.

## Running the code

  - see the toplevel Readme for instructions on starting the server
  - open the flutter-example project with Android Studio or VS Code
  - get dependencies with 'pub get' (might update automatically)
  - start an Android Emulator of your choise
  - start a debug session

That should get some output showing what happened.

## Restarting the server

if you create the same user more than once, you will get 'duplicate email' warnings since the server
already has the users created. That's a good test, but if you want to rerun from scratch just restart
the server.

