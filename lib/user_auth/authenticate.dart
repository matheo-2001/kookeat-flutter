import 'package:flutter/material.dart';
import 'package:kookeat_app/common/loading.dart';
import 'package:kookeat_app/common/constants.dart';
import 'package:kookeat_app/services/authentication.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue,
            appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                elevation: 0.0,
                title: Text(showSignIn
                    ? 'Sign in to Water Social'
                    : 'Register to Water Social'),
                actions: <Widget>[
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(showSignIn ? 'Sign in' : 'Register',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () => toggleView(),
                  )
                ]),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'email'),
                          validator: (value) =>
                              value?.isEmpty ?? true ? "Enter an email" : null,
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: passwordController,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'password'),
                          obscureText: true,
                          validator: (value) => value != null &&
                                  value.length < 4
                              ? "Enter a password with at least 4 characters"
                              : null,
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          child: Text(
                            showSignIn ? "Sign In" : "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() => loading = true);
                              var password = passwordController.text;
                              var email = emailController.text;

                              // TODO call firebase auth
                              dynamic result = showSignIn 
                              ? await _auth.signInWithEmailAndPassword(email, password)
                              : await _auth.registerWithEmailAndPassword(email, password);                                                  
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Please supply a valid error message here.';
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 10.0),
                        Text( 
                          error,
                          style: TextStyle(color:Colors.red, fontSize: 15.0),
                        )
                      ],
                    ))));
  }
}
