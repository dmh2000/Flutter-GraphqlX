const Subscription = {
  // SUBSCRIBE step 1 : define the subscription
  user: {
    subscribe(parent, args, { db, pubsub }, info) {
      return pubsub.asyncIterator('user');
    }
  }
};

export default Subscription;
