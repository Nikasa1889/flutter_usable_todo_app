import 'package:flutter/material.dart';
import 'package:usabletodoapp/models/todo.dart';

class TodoListTile extends StatefulWidget {
  final Function(String) onDismissed;
  final Function(Todo) onChanged;
  final Todo todo;
  final bool autofocus;

  TodoListTile(
      {@required this.todo,
      @required this.autofocus,
      @required this.onDismissed,
      @required this.onChanged})
      : super(key: Key(todo.key));
  @override
  _TodoListTileState createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  final TextEditingController todoEditingController = TextEditingController();

  @override
  void dispose() {
    todoEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoEditingController.text = widget.todo.subject;
    return Dismissible(
      key: Key(widget.todo.key),
      background: Container(color: Theme.of(context).errorColor),
      onDismissed: (direction) => widget.onDismissed(widget.todo.key),
      child: ListTileTheme(
        contentPadding: EdgeInsets.only(left: 0.0, right: 5.0),
        child: Card(
          margin: EdgeInsets.all(0.1),
          child: ListTile(
            leading: Checkbox(
              value: widget.todo.completed,
              onChanged: (bool value) {
                widget.todo.completed = value;
                widget.onChanged(widget.todo);
              },
            ),
            title: TextField(
              controller: TextEditingController(text: widget.todo.subject),
              autofocus: widget.autofocus,
              style: widget.todo.completed
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: null, // Set null for auto expand vertically
              keyboardType: TextInputType.text,
              enabled: true,
              onSubmitted: (String text) {
                widget.todo.subject = text;
                widget.onChanged(widget.todo);
              },
            ),
            trailing: Icon(Icons.drag_handle),
          ),
        ),
      ),
    );
  }
}
