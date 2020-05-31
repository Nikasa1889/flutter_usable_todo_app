import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usabletodoapp/components/todo_list_tile.dart';
import 'package:usabletodoapp/models/todo.dart';
import 'package:usabletodoapp/services/notification_service.dart';
import 'package:usabletodoapp/services/todo_list_service.dart';

class ReorderableTodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoListService = Provider.of<TodoListService>(context);

    void _onTodoDismissed(String todoKey) =>
        todoListService.deleteTodo(todoKey).catchError((error) {
          notifyError(context, message: error);
        });

    void _onTodoReordered(int oldIdx, int newIdx) {
      todoListService.reorderTodo(oldIdx, newIdx).catchError((error) {
        notifyError(context, message: error);
      });
    }

    void _onTodoChanged(Todo todo) {
      if (todo.subject.isEmpty) {
        todoListService.deleteTodo(todo.key);
      } else {
        todoListService.updateTodo(todo).catchError((error) {
          notifyError(context, message: error);
        });
      }
    }

    var todoList = todoListService.todoList;
    return ReorderableListView(
      onReorder: _onTodoReordered,
      children: List.generate(todoList.length, (index) {
        return TodoListTile(
            todo: todoList[index],
            autofocus: (index == todoList.length - 1) &&
                todoList[index].subject.isEmpty,
            onDismissed: _onTodoDismissed,
            onChanged: _onTodoChanged);
      }),
    );
  }
}
