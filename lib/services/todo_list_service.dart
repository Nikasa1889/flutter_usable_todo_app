import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:flutter/material.dart';
import 'package:usabletodoapp/models/todo.dart';
import 'package:usabletodoapp/services/config_service.dart';

class TodoListService with ChangeNotifier {
  ConfigService _config;
  FirebaseDatabase _db;
  DatabaseReference _todoRootRef;

  // This todoList is kept in sync with server-side at all time.
  List<Todo> _todoList = [];

  StreamSubscription<Event> todoListSubscription;

  TodoListService._(
      FirebaseUser user, FirebaseDatabase database, ConfigService config) {
    _config = config;
    _db = database;
    _db.setPersistenceEnabled(true);
    _todoRootRef = _db
        .reference()
        .child(config.getUserTodoListURI(user.uid))
        // .orderByPriority() (or related methods) does not work for now due to
        // https://github.com/FirebaseExtended/flutterfire/issues/753
        .reference();
    _todoRootRef.keepSynced(true);
    todoListSubscription = _todoRootRef.onValue.listen(_onTodoListChanged);
  }

  // Factory method for TodoListService.
  // Guarantees that _todoList is synced when the returned future is done.
  static Future<TodoListService> create(FirebaseUser user,
      FirebaseDatabase database, Future<ConfigService> config) async {
    var todoListService = TodoListService._(user, database, await config);
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
      return Future.error("Error deleting a todo item");
    }
  }

  // Todo's key is ignored and set automatically by the service.
  Future<void> createTodo(Todo todo) async {
    if (todoList.length >= _config.getMaxTodos()) {
      return Future.error(
          "Sorry, you can't have more than ${_config.getMaxTodos()} todo, "
          "please clear some first so you won't be overwhelmed!");
    }
    try {
      await _todoRootRef.push().set(todo.toJson(), priority: todo.priority);
    } catch (e) {
      return Future.error("Error while adding a todo item");
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _todoRootRef
          .child(todo.key)
          .set(todo.toJson(), priority: todo.priority);
    } catch (e) {
      return Future.error("Error while updating a todo item");
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
