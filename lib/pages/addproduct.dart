import 'dart:io';
import 'package:bakeryshop_project/pages/navbar/adminnavbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bakeryshop_project/pages/adminindex.dart';
import 'package:path/path.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _subMenuController = TextEditingController();
  String isRadio = "";

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  File? _image;
  final picker = ImagePicker();

  Future<void> _chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = "${_nameController.text}_${DateTime.now().toString()}";
    Reference ref = storage.ref().child('images/$fileName');
    UploadTask uploadTask = ref.putFile(_image!);

    await uploadTask.whenComplete(() => print('File Uploaded'));
    String imageURL = await ref.getDownloadURL();

    return imageURL;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AddProduct Page",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add products',
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
                    builder: (context) => Homeadmin(isLoggedIn: true),
                  ),
                );
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: const MyStatefulWidget(),
        bottomNavigationBar: const AdminNavbarWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _subMenuController = TextEditingController();
  List<String> _subMenuOptions = ['cake', 'donut', 'bread'];

  File? _image;
  final picker = ImagePicker();

  Future<void> _chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      return '';
    }

    String fileName = basename(_image!.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('product_images').child(fileName);
    UploadTask uploadTask = ref.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }

  String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 241, 188),
      child: ListView(
        children: <Widget>[
          Form(
            child: Column(
              children: <Widget>[
                // TextFormField for product id
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'Product ID',
                  ),
                ),
                // TextFormField for product name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                  ),
                ),
                // TextFormField for product price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Product Price',
                  ),
                ),
                // DropdownButton for sub-menu options
                DropdownButton<String>(
                  value: _selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  items: _subMenuOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Select Sub-Menu'),
                ),
                // Container for image selection and display
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _image == null
                          ? Text('No image selected.')
                          : Image.file(_image!, width: 200, height: 200),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _chooseImage,
                        child: const Text('Choose Image'),
                      ),
                    ],
                  ),
                ),
                // Add button
                ElevatedButton(
                  onPressed: () async {
                    String imageURL = await _uploadImage();
                    await products.add({
                      'id': _idController.text,
                      'name': _nameController.text,
                      'price': _priceController.text,
                      'image': imageURL,
                      'subMenu': _selectedOption,
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homeadmin(isLoggedIn: true),
                      ),
                    );
                  },
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
