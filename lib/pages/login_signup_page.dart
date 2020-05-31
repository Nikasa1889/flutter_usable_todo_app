import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:usabletodoapp/components/decorated_text_form_field.dart';
import 'package:usabletodoapp/components/two_colors_button.dart';
import 'package:usabletodoapp/services/authentication_service.dart';
import 'package:usabletodoapp/services/notification_service.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth});

  final AuthService auth;

  @override
  State<StatefulWidget> createState() => _LoginSignupPageState();
}

enum LoginSignupState { LOGGING_IN, SIGNING_UP }

class _LoginSignupPageState extends State<LoginSignupPage> {
  static final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LoginSignupState state = LoginSignupState.LOGGING_IN;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onLogin() async {
      if (_formKey.currentState.validate()) {
        widget.auth
            .signIn(emailController.text, passwordController.text)
            .then((user) {
          notifySuccess(context,
              message: "Successfully Logged in as ${user.email}");
        }).catchError((error) {
          notifyError(context, title: "Error Login!", message: error);
        });
      }
    }

    void _onSignUp() async {
      if (_formKey.currentState.validate()) {
        widget.auth
            .signUp(emailController.text, passwordController.text)
            .then((user) {
          notifySuccess(context,
              message: "Successfully signed up and logged in as ${user.email}");
        }).catchError((error) {
          notifyError(context, title: "Error Signing Up!", message: error);
        });
      }
    }

    void _onLoginAnonymously() async {
      widget.auth.signInAnonymously().then((user) {
        notifySuccess(context, message: "Logged in Anonymously");
      }).catchError((error) {
        notifyError(context, title: "Error Login!", message: error);
      });
    }

    final deviceSize = MediaQuery.of(context).size;
    final logoWidth = deviceSize.height * 0.2;
    final formWidth = min(deviceSize.width * 0.75, 360.0);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: formWidth,
            // Use ListView allow keyboard shrinking screen.
            child: ListView(
              children: <Widget>[
                SizedBox(height: deviceSize.height * 0.05),
                _buildLogo(size: logoWidth),
                SizedBox(height: deviceSize.height * 0.05),
                Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          _buildEmailInput(controller: emailController),
                          SizedBox(height: 10),
                          _buildPasswordInput(controller: passwordController),
                          SizedBox(height: 10),
                          if (state == LoginSignupState.SIGNING_UP)
                            _buildPasswordConfirmInput(
                                passwordController: passwordController),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildLoginButton(
                                onPressedWhileLoggingIn: _onLogin,
                                onPressedWhileNotLoggingIn: () =>
                                    _setState(LoginSignupState.LOGGING_IN),
                                state: state,
                              ),
                              _buildSignupButton(
                                  onPressedWhileSigningUp: _onSignUp,
                                  onPressedWhileNotSigningUp: () =>
                                      _setState(LoginSignupState.SIGNING_UP),
                                  state: state),
                            ],
                          ),
                          _buildSigninAnnonymouslyButton(
                              onPressed: _onLoginAnonymously),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // allows form card shadow.
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo({@required size}) {
    return Hero(
      tag: 'Logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size / 2,
        child: Image.asset('assets/todo_app_icon_75dpi.png'),
      ),
    );
  }

  Widget _buildEmailInput({@required controller}) {
    return DecoratedTextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      hintText: 'Email',
      prefixIcon: Icons.mail,
      validator: EmailValidator(errorText: 'Email is invalid'),
    );
  }

  Widget _buildPasswordInput({@required controller}) {
    return DecoratedTextFormField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      hintText: 'Password',
      prefixIcon: Icons.lock,
      validator: MultiValidator([
        RequiredValidator(errorText: 'Password is required'),
        MinLengthValidator(8,
            errorText: 'Password must be at least 8 character long'),
      ]),
    );
  }

  Widget _buildPasswordConfirmInput({@required passwordController}) {
    return DecoratedTextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      hintText: 'Retype password',
      prefixIcon: Icons.lock,
      validator: (val) => MatchValidator(errorText: 'Password does not matched')
          .validateMatch(val, passwordController.text),
    );
  }

  Widget _buildLoginButton({@required onPressedWhileLoggingIn,
    @required onPressedWhileNotLoggingIn,
    @required LoginSignupState state}) {
    return TwoColorsButton(
        text: 'LOGIN',
        onPressed: state == LoginSignupState.LOGGING_IN
            ? onPressedWhileLoggingIn
            : onPressedWhileNotLoggingIn,
        primary: state == LoginSignupState.LOGGING_IN);
  }

  Widget _buildSignupButton({@required onPressedWhileSigningUp,
    @required onPressedWhileNotSigningUp,
    @required LoginSignupState state}) {
    return TwoColorsButton(
        text: 'SIGNUP',
        onPressed: state == LoginSignupState.SIGNING_UP
            ? onPressedWhileSigningUp
            : onPressedWhileNotSigningUp,
        primary: state == LoginSignupState.SIGNING_UP);
  }

  Widget _buildSigninAnnonymouslyButton({@required onPressed}) {
    return OutlineButton(
      child: Text('Login Annonymously'),
      onPressed: onPressed,
    );
  }

  void _setState(LoginSignupState state) {
    setState(() {
      this.state = state;
    });
  }
}
