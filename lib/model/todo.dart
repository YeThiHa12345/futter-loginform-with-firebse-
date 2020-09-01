import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Todo {
  String key;
  String subject;
  bool completed;
  String userId;

  Todo(this.subject, this.completed, this.userId);
  Todo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"];

  toJson() {
    return {"userId": userId, "subject": subject, "completed": completed};
  }
}
