class Todo {
  // Unique key for each Todo. The key is generated automatically by Firebase.
  String key;
  // The subject and also the only content of the Todo.
  String subject;
  // Indicates if the Todo is marked as completed.
  bool completed;
  // The userId that this Todo belongs to.
  String userId;
  // The priority used to implicitly order todos in the todo list.
  // Smaller means higher priority.
  int priority;

  Todo(this.subject, this.userId, this.completed, this.priority);

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
