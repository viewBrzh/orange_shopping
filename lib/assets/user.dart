class User {
  int id = 0;
  String username = '';
  String password = '';

  User(this.id, this.username, this.password);
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['username'],
      json['password_hash']
    );
  }
}
