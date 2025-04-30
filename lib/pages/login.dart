import 'landingscreen.dart';
import 'signup.dart';
import 'package:lw/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  bool _obscureText = true;
  String _email = "";
  String _password = "";
  String _username = "";
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthenticationService _authService =
      AuthenticationService(FirebaseAuth.instance);
  final DateTime timestamp = DateTime.now();

  _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _LoginUser();
    } else {
      print("Form is Invalid");
    }
  }

  _LoginUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await _authService.signIn(_email, _password);

    logMessage == "Signed In"
        ? _showSuccessSnack(logMessage)
        : _showErrorSnack(logMessage);

    if (logMessage == "Signed In") {
      Navigator.pushNamed(context, "/landingscreen");
      return;
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _showSuccessSnack(String message) async {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: TextStyle(color: Colors.green),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState?.reset();
  }

  _showErrorSnack(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    setState(() {
      _isSubmitting = false;
    });
  }

  // _createUserInFirestore() async {
  //   Navigator.pushNamed(context, "/landingScreen");
  //   _authService.addUserToDB(auth.currentUser!.uid, _username, auth.currentUser!.email.toString(), timestamp);
  // }

  // _signInWithGoogle() {
  //   String logMessage = _authService.signInWithGoogle();
  //   if (logMessage == "12") {
  //     _createUserInFirestore();
  //     _showSuccessSnack("Signed In");
  //   } else {
  //     _showErrorSnack(logMessage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Log In"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Log In", style: TextStyle(
                    fontSize: 60, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onSaved: (value) => _email = value.toString(),
                          validator: (value) =>
                              !value!.contains("@") ? "Invalid Email" : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              hintText: "Enter Valid Email",
                              icon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onSaved: (value) => _password = value.toString(),
                          validator: (value) =>
                              value!.length < 6 ? "Password Is Too Short" : null,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              hintText: "Enter Valid Password",
                              icon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _isSubmitting == true
                                ? Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).primaryColor),
                                    ),
                                )
                                : ElevatedButton(
                                    onPressed: _submit,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Theme.of(context).primaryColor),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/sign-up");
                  }, 
                  child: Text("Don't have an account? Sign Up")
                ),
                SizedBox(height: 50),
                Text("Other Providers", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Please Confirm'),
                                content: Text("This action CREATES a new user account via Google. Do you want to continue?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text('Cancel')
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      //Navigator.pop(context);

                                      _showErrorSnack("Not implemented yet. See code. Was getting error at last moment.");

                                     // final TextEditingController textFieldController = TextEditingController();

                                      // showDialog(
                                      //   context: context, 
                                      //   builder: (context) {
                                      //     return AlertDialog(
                                      //       title: const Text('Enter your Username'),
                                      //       content: TextField(
                                      //         controller: textFieldController,
                                      //         decoration: const InputDecoration(hintText: 'Enter your username'),
                                      //       ),
                                      //       actions: [
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             Navigator.pop(context);
                                      //           }, 
                                      //           child: const Text('Cancel')
                                      //         ),
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             if (textFieldController.text.isNotEmpty) {
                                      //               _username = textFieldController.text;
                                      //               textFieldController.clear();
                                      //               // _signInWithGoogle();
                                      //               _showErrorSnack("Not implemented yet. See code. Was getting error at last moment.");
                                      //               Navigator.pop(context);
                                      //             }
                                      //           }, 
                                      //           child: const Text('Confirm')
                                      //         ),
                                      //       ],
                                      //     );
                                      //   }, 
                                      // );
                                    
                                    },
                                    child: const Text('Conitnue')
                                  ),
                                ],
                              );
                            }
                          );
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100))),
                        ),
                        icon: Image.asset("assets/google.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
