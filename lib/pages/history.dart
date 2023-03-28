import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _query;
  late String _currentUserEmail;

  @override
  void initState() {
    super.initState();
    final currentUser = _auth.currentUser;
    _currentUserEmail = currentUser?.email ?? 'Anonymous';
    _query = _firestore
        .collection('carts')
        .where('email', isEqualTo: _currentUserEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final items = snapshot.data!.docs;
          if (items.isEmpty) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartData = items[index].data() as Map<String, dynamic>;
              final orderTime = cartData['orderTime'] as Timestamp;
              final itemsData = cartData['items'] as List<dynamic>;

              final formatter = DateFormat('dd MMMM yyyy, HH:mm');
              final orderTimeString = formatter.format(orderTime.toDate());

              return Card(
                margin: EdgeInsets.all(10.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text('Order Date: $orderTimeString'),
                    ),
                    Divider(),
                    ...itemsData.map((itemData) {
                      final productName = itemData['productName'] as String;
                      final quantity = itemData['quantity'] as int;
                      final price = itemData['price'] as String;
                      final totalPrice = itemData['totalPrice'] as String;

                      return ListTile(
                        leading: Text(
                          '$productName x $quantity',
                        ),
                        trailing: Text('$totalPrice THB'),
                        subtitle: Text('Price: $price THB'),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
