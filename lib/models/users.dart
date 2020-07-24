import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String college;
  final String batch;

  User({
    this.id,
    this.username,
    this.college,
    this.batch,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      college: doc['college'],
      batch: doc['batch'],
    );
  }
}
