# GraphqlX - Simple Example of using GraphQL with Flutter

This is the second article in a planned series of SIMPLE examples of certain Flutter packages. I mean simple, because I am not that smart and I like to see simple examples. Sometimes software examples are more complex than they need to be. 

## graphql_flutter

This is about building a Flutter app using the package [graphql_flutter](https://pub.dev/packages/graphql_flutter). This package created by the engineers at [Zino App BV](https://www.zinoapp.com/). They also have the package [graphql](https://pub.dev/packages/graphql) for standalone dart applications. These two packages used Apollo client as inspiration so anyone used to Apollo will probably feel at home. 

The Flutter package provides Widgets that support integration of Graphql queries, mutations and subscriptions into a Flutter app. I found it pretty easy to use. 

## A Graphql server

These packages are client side packages so you need a graphql server to test agains. The 'server' directory has a very simple (again) graphql server written for node.js using the [graphql_yoga](https://github.com/prisma/graphql-yoga) framework. Sometimes there are questions about using this package vs Apollo Server. In fact graphql_yoga is built on top of Apollo Server and Express and reduces the boilerplate overhead required. 

To run the server, you need node.js (v8 or later) installed. then cd into 'server', run 'npm install', then 'npm start'. If you point your browser at http://localhost:4000 you will get an instance of Graphql Playground to test against. That url is also the endpoint for client access. 

## Schema

Graphql of course requires a schema. The schema contains a single 'Users' datastore with queries for finding and listing users, a mutation for adding a user, and a subscription to the datastore. It is documented in 'server/src/db.js
