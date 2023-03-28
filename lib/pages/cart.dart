import 'package:bakeryshop_project/pages/adminshowproduct.dart';
import 'package:bakeryshop_project/pages/index.dart';
import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  final String type;
  int quantity;

  CartItem(
      {required this.name,
      required this.price,
      required this.type,
      this.quantity = 1});
}

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _incrementQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (widget.cartItems[index].quantity > 1) {
        widget.cartItems[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  void _goshop() {
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => Home(isLoggedIn: true),
      ),
    );
  }

  Future<void> _orderNow() async {
    final cartCollection = _firestore.collection('carts');
    final currentUser = _auth.currentUser;
    final orderTime = Timestamp.now();
    int totalAmount = 0;

    List<Map<String, dynamic>> cartItemsData = [];

    for (CartItem cartItem in widget.cartItems) {
      int itemTotalPrice = int.parse(cartItem.price) * cartItem.quantity;
      totalAmount += itemTotalPrice;

      cartItemsData.add({
        'productName': cartItem.name,
        'quantity': cartItem.quantity,
        'price': cartItem.price,
        'totalPrice': itemTotalPrice.toString(),
      });
    }

    await cartCollection.add({
      'email': currentUser?.email ?? 'Anonymous',
      'orderTime': orderTime,
      'items': cartItemsData,
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Successful'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Order Details:'),
                SizedBox(height: 10),
                ...widget.cartItems.map((cartItem) => Text(
                    '${cartItem.name} x ${cartItem.quantity} = ${int.parse(cartItem.price) * cartItem.quantity} THB')),
                SizedBox(height: 10),
                Text('Subtotal: $totalAmount THB'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตะกร้าสินค้า',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 20,
            color: const Color(0xFF545D68),
          ),
        ),
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminShowProduct(isLoggedIn: true),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = widget.cartItems[index];
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
                  leading: Text(cartItem.name),
                  title: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(index),
                      ),
                      Text(
                        cartItem.quantity.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _incrementQuantity(index),
                      ),
                    ],
                  ),
                  subtitle: Text('Price: ${cartItem.price} THB'),
                  trailing: Text(
                      'Total: ${int.parse(cartItem.price) * cartItem.quantity} THB'),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _removeItem(index),
                      icon: Icon(Icons.cancel),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _goshop,
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Add Item"),
          ),
          ElevatedButton(
            onPressed: _orderNow,
            child: Text('Order Now'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              textStyle: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
