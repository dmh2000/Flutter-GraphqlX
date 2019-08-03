import Query from './Query';
import Mutation from './Mutation';
import Users from './Users';
import Subscription from './Subscription';

const Resolvers =
  // Resolvers
  {
    Query: Query,
    Mutation: Mutation,
    User: Users,
    Subscription: Subscription
  };

export default Resolvers;
