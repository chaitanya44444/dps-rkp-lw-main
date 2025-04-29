import 'package:lw/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  User? _user;

  bool _obscureText = true;
  bool _isSubmitting = false;
  bool gContinue = false;
  // final TextEditingController _textFieldController = TextEditingController();

  String _username = "";
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);
  final DateTime timestampNow = DateTime.now();

  _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print("Email $_email, Password $_password, Username $_username");
      _registerUser();
    } else {
      print("Form is Invalid");
    }
  }

  _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await _authService.signUp(_email, _password);

    logMessage == "Signed Up"
        ? _showSuccessSnack(logMessage)
        : _showErrorSnack(logMessage);

    print(logMessage);

    if (logMessage == "Signed Up") {
      if (mounted) {
        Navigator.pushNamed(context, "/interests", arguments: _username);
      }
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _showSuccessSnack(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: TextStyle(color: Colors.green[100]),
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
        style: TextStyle(color: Colors.red[100]),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  // _signInWithGoogle() {
  //   String logMessage = _authService.signInWithGoogle();
  //   if (logMessage == "12") {
  //     _createUserInFirestore();
  //     _showSuccessSnack("Registed");
  //   } else {
  //     _showErrorSnack(logMessage);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Register"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onSaved: (value) => _username = value.toString(),
                          validator: (value) => value.toString().length < 6
                              ? "Username is too short."
                              : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Username",
                              hintText: "Enter Valid Username",
                              icon: Icon(
                                Icons.badge,
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onSaved: (value) => _email = value.toString(),
                          validator: (value) => !value.toString().contains("@")
                              ? "Invalid Email"
                              : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                          validator: (value) => value.toString().length < 6
                              ? "Password Is Too Short"
                              : null,
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                                : SizedBox(
                                  width: double.maxFinite,
                                  child: ElevatedButton(
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
                                        "Register",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/log-in");
                  }, 
                  child: Text("Already have an accout? Log In")
                ),
                SizedBox(height: 50),
                Text(
                  "Other Providers",
                  style: TextStyle(
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

                          _showErrorSnack("Not implemented yet. See code. Was getting error at last moment.");
                          // showDialog(
                          //   context: context, 
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       title: const Text('Enter your Username'),
                          //       content: TextField(
                          //         controller: _textFieldController,
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
                          //             if (_textFieldController.text.isNotEmpty) {
                          //               _username = _textFieldController.text;
                          //               _textFieldController.clear();
                          //               _signInWithGoogle();
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
