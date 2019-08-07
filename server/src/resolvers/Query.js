import uuidv1 from 'uuid/v1';

const Query = {
  user(parent, args, { db }, info) {
    console.log('---------> USER');
    return db.users.find(v => v.id === args.id);
  },

  users(parent, args, { db }, info) {
    console.log('---------> USERS');
    return db.users;
  }
};

export default Query;
