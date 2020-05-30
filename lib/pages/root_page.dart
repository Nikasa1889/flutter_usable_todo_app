import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usabletodoapp/pages/login_signup_page.dart';
import 'package:usabletodoapp/services/authentication_service.dart';
import 'package:usabletodoapp/services/todo_list_service.dart';

import 'home_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return FutureBuilder(
      future: auth.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LoginSignupPage(auth: auth);
          } else {
            return HomePage(
              user: user,
              futureTodoListService: TodoListService.create(user),
            );
          }
        }
      },
    );
  }
}
