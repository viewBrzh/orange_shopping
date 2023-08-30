import 'package:flutter/material.dart';
import 'package:orange_shopping/screen/buy.dart';
import '../assets/product.dart';
import 'package:orange_shopping/assets/dataKeeper.dart';
import 'package:orange_shopping/assets/user_cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orange_shopping/assets/apiUrl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<UserCart> userCartList = [];
  List<Product> currentUserCartList = [];
  List<Product> selectedProducts = [];
  List<Product> productList = [];
  Map<int, List<Product>> userCartMap = {};
  int selected = 0;

  @override
  void initState() {
    fetchProducts().then((_) {
      fetchUserCart().then((_) {
        fetchCurrentUserCart();
      });
    });
    super.initState();
  }

  Future<void> fetchUserCart() async {
    try {
      final userCartResponse = await http.get(Uri.parse('${apiUrl}userCart'));

      if (userCartResponse.statusCode == 200) {
        final List<dynamic> userCartData = json.decode(userCartResponse.body);

        List<UserCart> userCarts = userCartData.map((item) => UserCart.fromJson(item)).toList();

        for (var userCart in userCarts) {
          if (userCartMap.containsKey(userCart.user_id)) {
            userCartMap[userCart.user_id]!.add(productList.firstWhere((product) => product.id == userCart.product_id));
          } else {
            userCartMap[userCart.user_id] = [productList.firstWhere((product) => product.id == userCart.product_id)];
          }
        }

        setState(() {
          userCartList = userCarts;
        });
      } else {
        throw Exception('Failed to fetch user cart data');
      }
    } catch (e) {
      print('Error fetching user cart data: $e');
    }
  }

  Future<void> fetchCurrentUserCart() async {
    currentUserCartList = userCartMap[currentUser.id] ?? [];
  }

  Future<void> fetchProducts() async {
    try {
      final productsResponse = await http.get(Uri.parse('${apiUrl}products'));

      if (productsResponse.statusCode == 200) {
        final List<dynamic> productsData = json.decode(productsResponse.body);

        List<Product> products = productsData.map((item) => Product.fromJson(item)).toList();

        setState(() {
          productList = products;
        });
      } else {
        throw Exception('Failed to fetch products and stores');
      }
    } catch (e) {
      print('Error fetching products and stores: $e');
    }
  }

  void _toggleProductSelection(Product product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
        selected--;
      } else {
        selectedProducts.add(product);
        selected++;
      }
    });
  }

  void _removeProductFromCart(Product product) async {
    try {
      final response = await http.delete(
        Uri.parse('${apiUrl}removeFromCart'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': currentUser.id,
          'product_id': product.id,
        }),
      );

      if (response.statusCode == 200) {
        // Product successfully removed from the database, update UI as needed
        setState(() {
          // Remove only one instance of the product from the lists
          currentUserCartList.remove(product);
          selectedProducts.remove(product);
        });
      } else {
        print('Failed to remove product from cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }


  Product _checkProduct(Product product) {
    if (product.img == ''){
      product.img = 'lib/images/empty_cart.png';
      product.name = 'Your Cart Is Currently Empty!';
      return product;
    }
    else {
      return product;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
                Text(
                  'User Cart',
                  style: TextStyle(
                    color: Color(0xFFE5750E),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${currentUser.username}',
                  style: TextStyle(
                    color: Color(0xFFE5750E),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              
              ]
            ),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentUserCartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = currentUserCartList[index];
                    product = _checkProduct(product);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[200],
                      elevation: 0.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  _toggleProductSelection(product);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    selectedProducts.contains(product)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selectedProducts.contains(product)
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                8
                              ),
                              Image.network(
                                product.img ?? '',
                                width: 100,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error); // Display an error icon, for example
                                },
                              ),
                            ],
                          ),
                          title: Text('${product.name}'),
                          subtitle: Text(
                            '${product.price} THB',
                            style: TextStyle(
                              color: Color(0xFFE5750E),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_shopping_cart),
                            onPressed: () {
                              _removeProductFromCart(product);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,             
              children: [
                Text(
                    'Selected: ${selected}',
                    style: TextStyle(
                      color: Color(0xFFE5750E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyScreen(productL: selectedProducts),
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
          ],
        ),
      ),
    );
  }
}
