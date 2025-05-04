class User {
  String email;
  String username;
  String password;
  List<String> favorites;
  List<String> tried;

  User({
    required this.email,
    required this.username,
    required this.password,
    required this.favorites,
    required this.tried,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'password': password,
        'favorites': favorites,
        'tried': tried,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        username: json['username'],
        password: json['password'],
        favorites: List<String>.from(json['favorites']),
        tried: List<String>.from(json['tried']),
      );

  User copyWith({
    String? email,
    String? username,
    String? password,
    List<String>? favorites,
    List<String>? tried,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      favorites: favorites ?? this.favorites,
      tried: tried ?? this.tried,
    );
  }
}