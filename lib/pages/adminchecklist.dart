import 'package:bakeryshop_project/pages/navbar/adminnavbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({Key? key}) : super(key: key);

  @override
  _AdminHistoryPageState createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<Map<String, dynamic>>> _query;

  @override
  void initState() {
    super.initState();
    _query = _firestore
        .collection('carts')
        .orderBy('orderTime', descending: true)
        .snapshots()
        .asyncMap((cartsSnapshot) async {
      final carts = cartsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final usersSnapshot = await _firestore
          .collection('users')
          .where('email',
              whereIn: carts.map((cart) => cart['email']).toSet().toList())
          .get();
      final users = usersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return carts.map((cart) {
        final user = users.firstWhere((user) => user['email'] == cart['email']);
        return {
          'orderTime': cart['orderTime'],
          'items': cart['items'],
          'user': user,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'ประวัติการสั่งซื้อ',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 20,
            color: const Color(0xFF545D68),
          ),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartData = items[index];
              final orderTime = cartData['orderTime'] as Timestamp;
              final itemsData = cartData['items'] as List<dynamic>;
              final userData = cartData['user'] as Map<String, dynamic>;

              final formatter = DateFormat('dd MMMM yyyy, HH:mm');
              final order = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เวลาสั่งซื้อ: ${formatter.format(orderTime.toDate())}',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ชื่อลูกค้า: ${userData['firstName']} ${userData['lastName']}',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'อีเมลล์: ${userData['email']}',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'รายการสินค้า:',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: itemsData.map<Widget>((item) {
                      return Text(
                        '${item['name']} x${item['quantity']}',
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 16,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                ],
              );

              return order;
            },
          );
        },
      ),
      bottomNavigationBar: AdminNavbarWidget(),
    );
  }
}
