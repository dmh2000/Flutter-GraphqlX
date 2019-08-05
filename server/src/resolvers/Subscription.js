const Subscription = {
  user: {
    subscribe(parent, args, { db, pubsub }, info) {
      return pubsub.asyncIterator('user');
    }
  }
};

export default Subscription;
