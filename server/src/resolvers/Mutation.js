import uuidv1 from 'uuid/v1';

// ============================================
// USERS
// ============================================
function _createUser(db, pubsub, data) {
  // quit if email already in user
  const emailTaken = db.users.some(u => u.email === data.email);
  if (emailTaken) throw new Error('Duplicate Email');

  // create a user object
  const user = {
    id: uuidv1(),
    ...data
  };

  // add to users database
  db.users.push(user);

  // publish the user
  pubsub.publish('user', {
    user: {
      data: user
    }
  });

  // send to client
  return user;
}

function _deleteUser(db, id) {
  let user = db.users.find(u => u.id === id);
  if (user === null) throw new Error('User Not Found');

  // keep all users except this one
  db.users = db.users.filter(user => user.id !== id);

  return user;
}

const Mutation = {
  // USERS
  createUser(parent, args, { db, pubsub }, info) {
    return _createUser(db, pubsub, args.data);
  },
  deleteUser(parent, args, { db }, info) {
    return _deleteUser(db, args.id);
  }
};

export default Mutation;
