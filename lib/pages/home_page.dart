import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usabletodoapp/components/reorderable_todo_list.dart';
import 'package:usabletodoapp/models/todo.dart';
import 'package:usabletodoapp/services/authentication_service.dart';
import 'package:usabletodoapp/services/notification_service.dart';
import 'package:usabletodoapp/services/todo_list_service.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.user, @required this.futureTodoListService});
  final FirebaseUser user;
  final Future<TodoListService> futureTodoListService;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);

    void _onSignOut() async {
      try {
        await auth.signOut();
      } catch (error) {
        notifyError(context, title: "Error SignOut!", message: error);
      }
    }

    void _onNewTodoAdded(TodoListService todoListService) {
      var priority = todoListService.todoList.isEmpty
          ? 0
          : todoListService.todoList.last.priority + 1;
      todoListService.createTodo(Todo("", widget.user.uid, false, priority));
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Hero(
                tag: 'Logo',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset("assets/todo_app_icon_75dpi.png"),
                ),
              ),
              SizedBox(width: 10),
              Text('UsableTodos'),
            ],
          ),
          actions: <Widget>[_buildSignoutButton(onPressed: _onSignOut)],
        ),
        body: FutureBuilder<TodoListService>(
            future: widget.futureTodoListService,
            builder: (context, AsyncSnapshot<TodoListService> futureService) {
              if (futureService.hasData) {
                return ChangeNotifierProvider(
                    create: (_) => futureService.data,
                    child: ReorderableTodoList());
              } else {
                Widget content = CircularProgressIndicator();
                if (futureService.hasError) {
                  content = Text(
                      "Error while loading todo list, please check your connection.");
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[content],
                  ),
                );
              }
            }),
        floatingActionButton: FutureBuilder<TodoListService>(
            future: widget.futureTodoListService,
            builder: (context, futureService) {
              if (futureService.hasData) {
                return _buildAddTodoButton(
                    onPressed: () => _onNewTodoAdded(futureService.data));
              } else {
                return _buildAddTodoButton(onPressed: null);
              }
            }));
  }

  Widget _buildSignoutButton({@required onPressed}) =>
      IconButton(icon: Icon(Icons.power_settings_new), onPressed: onPressed);

  Widget _buildAddTodoButton({@required Function onPressed}) =>
      FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.add),
      );
}
