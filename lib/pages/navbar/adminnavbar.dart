import 'package:bakeryshop_project/pages/addproduct.dart';
import 'package:bakeryshop_project/pages/adminindex.dart';
import 'package:bakeryshop_project/pages/adminuserinfo.dart';
import 'package:bakeryshop_project/pages/cart.dart';
import 'package:bakeryshop_project/pages/history.dart';
import 'package:bakeryshop_project/pages/index.dart';
import 'package:bakeryshop_project/pages/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminNavbarWidget extends StatefulWidget {
  const AdminNavbarWidget({Key? key}) : super(key: key);

  @override
  _AdminNavbarWidgetState createState() => _AdminNavbarWidgetState();
}

class _AdminNavbarWidgetState extends State<AdminNavbarWidget> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    Homeadmin(isLoggedIn: true),
    AddProductPage(),
    AdminUserInfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _pages[index],
      ),
    );
  }

  Widget buildNavbarIcon(IconData iconData, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2, color: Color(0xFFEF7532)),
                ),
              )
            : null,
        child: Icon(
          iconData,
          color: isSelected ? Color(0xFFEF7532) : Color(0xFF676E79),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.transparent,
      elevation: 10,
      child: Container(
        height: 50.0.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0.r),
            topRight: Radius.circular(25.0.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavbarIcon(Icons.home, 0),
            buildNavbarIcon(Icons.add, 1),
            buildNavbarIcon(Icons.person_outline, 2),
          ],
        ),
      ),
    );
  }
}
