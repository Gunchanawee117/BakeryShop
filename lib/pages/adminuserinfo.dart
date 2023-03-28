// ignore_for_file: deprecated_member_use

import 'package:bakeryshop_project/pages/navbar/adminnavbar.dart';
import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AdminUserInfoPage extends StatefulWidget {
  const AdminUserInfoPage({Key? key}) : super(key: key);

  @override
  _AdminUserInfoPageState createState() => _AdminUserInfoPageState();
}

class _AdminUserInfoPageState extends State<AdminUserInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final ref =
          _storage.ref().child('user_avatars').child('${user!.uid}.jpg');
      final taskSnapshot = await ref.putFile(imageFile);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      await user!.updateProfile(photoURL: imageUrl);
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'avatar': imageUrl});
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Infomation',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 20,
            color: const Color(0xFF545D68),
          ),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL ?? ''),
                  radius: 80,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: _pickAndUploadImage,
                    icon: Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'ข้อมูลผู้ใช่งาน',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(user!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data?.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      _infoRow('name', data['username']),
                      _infoRow('email', data['email']),
                      _infoRow('Phone', data['phone']),
                      // _infoRow('Address', data['address']),
                      // Add more information fields here
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminNavbarWidget(),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? '',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
