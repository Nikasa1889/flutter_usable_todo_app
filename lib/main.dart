import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usabletodoapp/pages/root_page.dart';
import 'package:usabletodoapp/services/authentication_service.dart';

import 'themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Music Interval Trainer',
        theme: lightTheme,
        home: RootPage(),
      ),
    );
  }
}
