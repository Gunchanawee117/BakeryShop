import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void onLogin() {
    setState(() {
      isLoggedIn = true;
    });
    // ส่งไปหน้าถัดไปที่ต้องการ
  }

  void onLogout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body: Center(
          child: isLoggedIn
              ? const Text('Welcome back!')
              : ElevatedButton(
                  onPressed: () {
                    // ไปหน้า Login
                  },
                  child: const Text('Login'),
                ),
        ),
      ),
    );
  }
}
