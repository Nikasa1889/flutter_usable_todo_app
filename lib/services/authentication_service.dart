import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Future<FirebaseUser> signIn(String email, String password) async {
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return result.user;
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Email doesn't exist or password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Email doesn't exist or password is wrong.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Error signing in, please check your connection.";
      }
      return Future.error(errorMessage);
    }
  }

  Future<FirebaseUser> signInAnonymously() async {
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      notifyListeners();
      return result.user;
    } catch (error) {
      switch (error) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in anonymously is not enabled";
          break;
        default:
          errorMessage =
              "Error signing in anonymously, please check your connection";
      }
      return Future.error(errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (error) {
      return Future.error("Error while logging out.");
    }
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return result.user;
    } catch (error) {
      switch (error.code) {
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Password is too weak.";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Email address is malformed.";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "The email is already registered.";
          break;
        default:
          errorMessage =
              "Error while signing up, please check your connection.";
      }
      return Future.error(errorMessage);
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
