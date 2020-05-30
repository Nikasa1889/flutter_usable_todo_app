import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:flutter/material.dart';
import 'package:usabletodoapp/models/todo.dart';

// TODO: refactor to configuration service.
String getTodoTableOfUser(FirebaseUser user) {
  return "users/${user.uid}/todos/";
}

class TodoListService with ChangeNotifier {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _todoRootRef;

  // This todoList is kept in sync with server-side at all time.
  List<Todo> _todoList = [];

  StreamSubscription<Event> todoListSubscription;

  TodoListService._(FirebaseUser user) {
    _db.setPersistenceEnabled(true);
    _todoRootRef = _db
        .reference()
        .child(getTodoTableOfUser(user))
        // .orderByPriority() (or related methods) does not work for now due to
        // https://github.com/FirebaseExtended/flutterfire/issues/753
        .reference();
    _todoRootRef.keepSynced(true);
    todoListSubscription = _todoRootRef.onValue.listen(_onTodoListChanged);
  }
  // Factory method that return Future<TodoListService> that make sure todoList
  // is refreshed when the future is done.
  static Future<TodoListService> create(FirebaseUser user) async {
    var todoListService = TodoListService._(user);
    await todoListService._refreshTodoList();
    return todoListService;
  }

  void _sortByPriority() {
    _todoList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> _refreshTodoList() async {
    try {
      var snapshot = await _todoRootRef.once();
      Map<dynamic, dynamic> items = snapshot.value;
      _todoList.clear();
      items?.forEach((key, values) {
        _todoList.add(Todo.fromMap(key, values));
      });
      _sortByPriority();
    } catch (e) {
      return Future.error("Error while loading todo list");
    }
  }

  @override
  void dispose() {
    todoListSubscription.cancel();
    super.dispose();
  }

  void _onTodoListChanged(Event event) {
    Map<dynamic, dynamic> items = event.snapshot.value;
    _todoList.clear();
    items?.forEach((key, values) {
      _todoList.add(Todo.fromMap(key, values));
    });
    _sortByPriority();
    notifyListeners();
  }

  UnmodifiableListView<Todo> get todoList => UnmodifiableListView(_todoList);

  Future<void> deleteTodo(String todoKey) async {
    try {
      await _todoRootRef.child(todoKey).remove();
    } catch (e) {
      return Future.error("Error deleting the todo item");
    }
  }

  // Todo's key is ignored and set automatically by the service.
  Future<void> createTodo(Todo todo) async {
    try {
      await _todoRootRef.push().set(todo.toJson(), priority: todo.priority);
    } catch (e) {
      return Future.error("Error while adding the todo item");
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _todoRootRef
          .child(todo.key)
          .set(todo.toJson(), priority: todo.priority);
    } catch (e) {
      return Future.error("Error while updating the todo item");
    }
  }

  Future<void> _correctTodoPriority() async {
    try {
      for (int i = 0; i < _todoList.length; i++) {
        if (_todoList[i].priority != i) {
          _todoList[i].priority = i;
        }
      }
      // TODO: Store todo's priority in separate place.
      _todoRootRef.set({for (var todo in _todoList) todo.key: todo.toJson()});
    } catch (e) {
      return Future.error("Error while flattening todo priorities");
    }
  }

  Future<void> reorderTodo(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final oldTodo = _todoList.removeAt(oldIndex);
    _todoList.insert(newIndex, oldTodo);
    await _correctTodoPriority();
    notifyListeners();
  }
}
