import 'package:bakeryshop_project/pages/addproduct.dart';
import 'package:bakeryshop_project/pages/adminshowproduct.dart';
import 'package:bakeryshop_project/pages/history.dart';
import 'package:bakeryshop_project/pages/index.dart';
import 'package:bakeryshop_project/pages/navbar/adminnavbar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:bakeryshop_project/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homeadmin extends StatefulWidget {
  final bool isLoggedIn;
  final String? userEmail;

  const Homeadmin({Key? key, required this.isLoggedIn, this.userEmail})
      : super(key: key);

  @override
  _HomeadminState createState() => _HomeadminState();
}

class _HomeadminState extends State<Homeadmin>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 236, 177),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'BakeryShop',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 24.0.sp,
            color: const Color(0xFF545D68),
          ),
        ),
        actions: [
          Text(
            widget.userEmail ?? '',
            style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 18.0.sp,
              color: const Color(0xFF545D68),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF545D68)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(isLogin: false)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Text(
            "Admin Function",
            style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 24.0.sp,
              color: const Color(0xFF545D68),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(),
                  ),
                );
              },
              child: Text(
                "Add new Products +",
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
          SizedBox(height: 20),
          Container(
            height: 60,
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminShowProduct(isLoggedIn: true),
                  ),
                );
              },
              child: Text(
                "Show Product",
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
      bottomNavigationBar: const AdminNavbarWidget(),
    );
  }
}
