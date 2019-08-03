import { GraphQLServer, PubSub } from 'graphql-yoga';

import db from './src/db';
import Resolvers from './src/resolvers/Resolvers';

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
server.start(() => {
  console.log('server running');
});
