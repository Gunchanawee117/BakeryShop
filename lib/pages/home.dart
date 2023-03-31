import 'package:bakeryshop_project/pages/index.dart';
import 'package:bakeryshop_project/pages/login.dart';
import 'package:bakeryshop_project/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //ส่วนบนหน้าจอ home + รูป -------------------------------------

          Expanded(
              child: Container(
            color: Colors.amber,
            child: Center(
              child: Image.asset('images/logo.jpg'),
            ),
          )),

          //ส่วนล่างหน้าจอ home + text -------------------------------------

          Expanded(
              child: Container(
            color: Color.fromARGB(255, 247, 226, 153),
            width: 800,
            child: Column(
              children: [
                SizedBox(height: 15),
                Text(
                  "Welcome To BakeryShop",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 182, 117, 61)),
                ),
                Column(
                  children: [
                    Icon(Icons.bakery_dining),
                    Text(
                      "ขนมเค้กสดใหม่ อบใหม่ทุกวัน พร้อมเสริฟเพื่อคุณแล้ว",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Text(
                      "[ CakeBakery - เค้กเบเกอรี่ ]",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                Container(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(isLogin: false),
                        ),
                      );
                    },
                    child: Text(
                      "Go to Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 215, 98, 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Go to Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 237, 130, 73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
