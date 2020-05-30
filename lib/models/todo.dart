import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String subject;
  bool completed;
  String userId;
  int priority;

  Todo(this.subject, this.userId, this.completed, this.priority);

  Todo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"],
        // Sets default priority to a big number. This will be overrided
        // by TodoListService to keep priorities consecutive.
        priority = snapshot.value["priority"];

  Todo.fromMap(String key, Map values)
      : key = key,
        userId = values["userId"],
        subject = values["subject"],
        completed = values["completed"],
        priority = values["priority"];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
      "priority": priority
    };
  }
}
