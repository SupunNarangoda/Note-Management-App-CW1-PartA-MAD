class User {
  final int? id;
  final String email;
  final String password;



  User({
    this.id,
    required this.email,
    required this.password,
  });


  User.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        email = res['email'],
        password = res['password'];


  Map<String, Object?> toMap(){
    return {
      'id': id,
      'email' : email,
      'password' : password,
    };

  }

}