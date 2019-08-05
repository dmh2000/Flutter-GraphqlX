import { GraphQLServer, PubSub } from 'graphql-yoga';

import db from './db';
import Resolvers from './resolvers/Resolvers';

// subscription support
const pubsub = new PubSub();

// server configuration
const server = new GraphQLServer({
  typeDefs: './src/schema.graphql',
  resolvers: Resolvers,
  context: {
    db,
    pubsub
  }
});

console.log('starting...');
// specify keepAlive true if subscriptions are supported
// otherwise the client has to continually reconnect
server.start(
  {
    subscriptions: {
      path: '/',
      keepAlive: true
    }
  },
  () => {
    console.log('server running');
  }
);
