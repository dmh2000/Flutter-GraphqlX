// user type
class User {
  final String name;
  final String email;
  final String id;

  // default constructor with init parameters
  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromDynamic(data) {
    String id = data['id'];
    String name = data['name'];
    String email = data['email'];
    return User(id: id, name: name, email: email);
  }

  String toString() {
    return 'id:$id, name:$name, email:$email';
  }
}
