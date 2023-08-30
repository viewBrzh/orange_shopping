import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';
import 'package:orange_shopping/screen/buy.dart';
import 'package:orange_shopping/assets/dataKeeper.dart';
import '../assets/product.dart';
import '../assets/store.dart';
import 'package:orange_shopping/assets/apiUrl.dart';

class ProductDetail extends StatefulWidget {

  const ProductDetail({super.key});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<Product> productList = [];
  List<Store> storeList = [];

  @override
  void initState() {
    super.initState();
    fetchProductsAndStores();
  }

  Future<void> fetchProductsAndStores() async {
    try {
      final productsResponse = await http.get(Uri.parse('${apiUrl}products'));
      final storesResponse = await http.get(Uri.parse('${apiUrl}stores'));

      if (productsResponse.statusCode == 200 && storesResponse.statusCode == 200) {
        final List<dynamic> productsData = json.decode(productsResponse.body);
        final List<dynamic> storesData = json.decode(storesResponse.body);

        List<Product> products = productsData.map((item) => Product.fromJson(item)).toList();
        List<Store> stores = storesData.map((item) => Store.fromJson(item)).toList();

        setState(() {
          productList = products;
          storeList = stores;
        });
      } else {
        throw Exception('Failed to fetch products and stores');
      }
    } catch (e) {
      print('Error fetching products and stores: $e');
    }
  }

  Store? searchStore(Product product) {
    for (int i = 0; i < storeList.length; i++) {
      for (int j = 0; j < storeList[i].productList.length; j++) {
        if (storeList[i].productList[j].name == product.name) {
          Store store = storeList[i];
          print(store.name);
          return store;
        }
      }
    }
    return null; // Return null if store is not found
  }

Future<void> addToCart(int userId, int productId) async {
  final response = await http.post(
    Uri.parse('${apiUrl}cart/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'userId': userId,
      'productId': productId,
    }),
  );

  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    print('Product added to cart');
  } else {
    print('Failed to add product to cart');
  }
}


  _navigateToProductDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 32;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: AssetImage('lib/images/logo.png'),
                  width: 100,
                  height: 100,
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.grey,
                  onPressed: () {
                    // Handle cart button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.grey[300],
                  width: containerWidth,
                  height: 300,
                  padding: EdgeInsets.all(8),
                  child: Image.network(
                    currentProduct.img ?? '', // Use product image URL
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error); // Display an error icon, for example
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentProduct.price} THB',
                    style: TextStyle(
                      color: Color(0xFFE5750E),
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    '${currentProduct.name}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 57, 57, 57),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          (searchStore(currentProduct)?.image_url ?? ''),
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                      // Text(searchStore(currentProduct)?.image_url ?? ''),
                      SizedBox(width: 4),
                      Text(
                        (searchStore(currentProduct)?.name ?? ''),
                        style: TextStyle(
                          color: Color.fromARGB(255, 57, 57, 57),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle add to cart button press
                    addToCart(currentUser.id, currentProduct.id);
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Color(0xFFE5750E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    List<Product> productLs = [];
                    productLs.add(currentProduct);
                    // Handle buy button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyScreen(productL: productLs),
                      ),
                    );
                  },
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color: Color(0xFFE5750E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommend for you.',
                    style: TextStyle(color: Color(0xFFE5750E)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  Product product = productList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.grey[200],
                    elevation: 0.0,
                    child: GestureDetector(
                      onTap:() { 
                        currentProduct = product;
                        _navigateToProductDetail();
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Image.network(
                          product.img ?? '',
                          width: 100,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error); // Display an error icon, for example
                          },
                        ),
                        title: Text('${product.name}'),
                        subtitle: Text(
                          '${product.price} THB',
                          style: TextStyle(
                            color: Color(0xFFE5750E),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
