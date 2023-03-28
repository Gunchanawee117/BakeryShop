// import 'package:bakeryshop_project/pages/home.dart';
// import 'package:bakeryshop_project/pages/index.dart';
// import 'package:bakeryshop_project/pages/register.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:bakeryshop_project/pages/auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';

// class Loginpage extends StatelessWidget {
//   const Loginpage({Key? key}) : super(key: key);

//   static const String _title = "Login";

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.amberAccent,
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Indexpage(),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.arrow_back_ios)),
//         ),
//         body: const MyStatefulWidget(),
//       ),
//     );
//   }
// }

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         child: Container(
//             color: Color.fromARGB(255, 255, 241, 188),
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                     child: Container(
//                   color: Color.fromARGB(255, 255, 241, 188),
//                   child: Center(
//                     child: Image.asset('images/login.png'),
//                   ),
//                 )),
//                 Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(10),
//                   child: const Text(
//                     "Login",
//                     style: TextStyle(
//                         color: Colors.brown,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _emailController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     } else if (!value.contains('@')) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.account_box)),
//                 ),
//                 TextFormField(
//                   controller: _passwordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     } else if (!value.contains('')) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Password',
//                       prefixIcon: Icon(Icons.password)),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     height: 50,
//                     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     child: ElevatedButton(
//                       child: const Text('Login'),
//                       onPressed: () async {
//                         await FirebaseAuth.instance.signInWithEmailAndPassword(
//                           email: _emailController.text,
//                           password: _passwordController.text,
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => Indexpage()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color.fromARGB(255, 201, 97, 41),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         ),
//                       ),
//                     )),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   height: 50,
//                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                   child: ElevatedButton(
//                     child: const Text('Back'),
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 201, 97, 41),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     const Text('หากยังไม่มีบัญชี'),
//                     TextButton(
//                       child: const Text(
//                         '[สมัครที่นี่]',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RegisPage(),
//                           ),
//                         );
//                       },
//                     )
//                   ],
//                   mainAxisAlignment: MainAxisAlignment.center,
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }

import 'package:bakeryshop_project/pages/adminindex.dart';
import 'package:bakeryshop_project/pages/home.dart';
import 'package:bakeryshop_project/pages/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bakeryshop_project/pages/status.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required bool isLogin}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  @override
  bool isLoggedIn = false;

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user data from the Firebase Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check the user's level
      final userLevel = userDoc['userlevel'];
      if (userLevel == '2') {
        // Navigate to the status page if the user is an admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homeadmin(
              isLoggedIn: true,
              userEmail: userCredential.user!.email,
            ),
          ),
        );
      } else {
        // Navigate to the home page for regular users
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              isLoggedIn: true,
              userEmail: userCredential.user!.email,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // If the sign-in fails, display an error message.
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 238, 189),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  child: Container(
                color: Color.fromARGB(255, 255, 241, 188),
                child: Center(
                  child: Image.asset('images/login.png'),
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 201, 97, 41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Back'),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 201, 97, 41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
