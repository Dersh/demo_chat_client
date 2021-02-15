import 'package:meta/meta.dart';

class User {
  final String username;
  final String uid;
  User({@required this.username, @required this.uid})
      : assert(username != null),
        assert(uid != null);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
      'uid': this.uid,
    };
  }
}
