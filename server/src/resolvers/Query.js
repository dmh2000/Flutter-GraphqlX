import uuidv1 from 'uuid/v1';

const Query = {
  user(parent, args, { db }, info) {
    return db.users.find(v => v.id === args.id);
  },

  users(parent, args, { db }, info) {
    return db.users;
  }
};

export default Query;
