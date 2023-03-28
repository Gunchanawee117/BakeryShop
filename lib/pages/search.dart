import 'package:bakeryshop_project/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bakeryshop_project/pages/navbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CartItem> cartItems = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _productList(String searchText) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: searchText + 'z')
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
                          placeholder: 'assets/images/loading.gif',
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '$price THB',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            Type,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: TextField(
          autofocus: true,
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'ค้นหาสินค้า',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
              onPressed: () {},
            ),
          ),
          onSubmitted: (searchText) {},
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _productList(_searchController.text),
        ),
      ),
      // bottomNavigationBar: NavbarWidget(),
    );
  }
}
