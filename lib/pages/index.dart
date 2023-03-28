import 'package:bakeryshop_project/pages/adminindex.dart';
import 'package:bakeryshop_project/pages/cart.dart';
import 'package:bakeryshop_project/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final bool isLoggedIn;
  final String? userEmail;

  const Home({Key? key, required this.isLoggedIn, this.userEmail})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BakeryShop',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 20,
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
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(isLoggedIn: true),
                ),
              );
            },
            icon: Icon(Icons.bakery_dining_rounded)),
      ),
      body: Column(
        children: [
          TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: const Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 24),
              unselectedLabelColor: const Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text(
                    'เค้ก',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 20.0.sp,
                    ),
                  ),
                ),
                Tab(
                  child: Text('โดนัท',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 20.0.sp,
                      )),
                ),
                Tab(
                  child: Text('ขนมปัง',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 20.0.sp,
                      )),
                )
              ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _productList('cake'),
                _productList('donut'),
                _productList('bread'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }

  Widget _productList(String productType) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('products')
          .where('subMenu', isEqualTo: productType)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<DocumentSnapshot> item = snapshot.data!.docs;
        int itemCount = item.length;

        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.6),
          ),
          itemBuilder: (BuildContext context, int index) {
            final productListData = item[index].data() as Map<String, dynamic>;
            final String name = productListData['name'];
            final String price = productListData['price'];
            final String Type = productListData['subMenu'];
            final String imageURL = productListData['image'];

            return InkWell(
              onTap: () {
                final cartItem = CartItem(name: name, price: price, type: Type);
                bool itemExists = false;

                for (CartItem item in cartItems) {
                  if (item.name == cartItem.name) {
                    item.quantity++;
                    itemExists = true;
                    break;
                  }
                }

                if (!itemExists) {
                  cartItems.add(cartItem);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(cartItems: cartItems)),
                );
              },
              child: Card(
                color: Color.fromARGB(255, 255, 238, 189),
                margin: EdgeInsets.all(10.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: AspectRatio(
                        aspectRatio: 2.5,
                        child: FadeInImage.assetNetwork(
                          placeholder: ('images/loading.gif'),
                          image: imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('  Type : ' + Type),
                          Text('  Price : ' + price),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
