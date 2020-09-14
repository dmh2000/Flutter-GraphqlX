import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'screens/user_add_screen.dart';
import 'screens/users_screen.dart';
import 'screens/subscription.dart';

void main() {
// =========================================================
// init of link and client needs to be done outside the
// app class
// =========================================================
// create a 'Link' for the client
// If you only have queries and mutations, use an HttpLink.
// if you also use subscription(s), use a WebSocketLink
// instead. It supports queries and mutations as well.
// 10.0.2.2 is the Android Emulator IP that points to the
// workstation localhost
//
// The graphql_flutter API docs say that you need a global
// SocketClient object for subscriptions to work however
// in the Dart example that wasn't necessary if the 'Link'
// object is a WebSocketLink. So that is what is used here
// and it seems to work.  This may change in the future.
// =========================================================
  WebSocketLink link = WebSocketLink(
    url: 'ws://10.0.2.2:4000',
    config: SocketClientConfig(
      autoReconnect: true,
    ),
  );

// Wait for Servicebinding initialization
  WidgetsFlutterBinding.ensureInitialized();

// =========================================================
// create a client with a link and a cache object
// the Graphql library caches anything it can to improve
// performance. I'm guessing that it will cache queries
// if no mutation has been executed since the previous query
// =========================================================
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => UsersScreen(),
            '/add_user': (context) => UserAddScreen(),
            '/subscription': (context) => UserScreen(),
          }),
    );
  }
}
