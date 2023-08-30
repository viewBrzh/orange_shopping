import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';
import 'package:orange_shopping/assets/apiUrl.dart';
import 'package:orange_shopping/assets/product.dart';
import 'package:orange_shopping/assets/dataKeeper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductCategory? selectedCategory;
  List<Product> productList = [];

  _navigateToProductDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

   Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Product> products = [];
        for (var item in data) {
          products.add(Product.fromJson(item));
        }
        setState(() {
          productList = products; // Update the productList state
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  List<Product> getFilteredProducts() {
    if (selectedCategory == null || selectedCategory == ProductCategory.All) return productList;
    return productList.where((product) => product.cate == getCategoryString(selectedCategory)).toList();
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
                  width: 100, // Set the width to 100 pixels (adjust as needed)
                  height: 100,
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart), 
                  color: Colors.grey, 
                  onPressed: () {
                    // if (usCart.productList[0].name == ''){
                    //   usCart.productList[0].name = 'Your Cart Is Currently Empty!';
                    //   usCart.productList[0].img = 'lib/images/empty_cart.png';
                    // }
                          
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  }
                )
              ],
            ),
            
          ],
        ),
      ),
      body: ListView( 
        children: [
          Center(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daily recommend',
                style: TextStyle(
                  color: Color(0xFFE5750E),
                ),
              ),
            )
          ),
          
          Stack( 
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: 250,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 4),
                  ),
                  items: productList.map((product) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            currentProduct = product;
                            _navigateToProductDetail();
                          },
                          child: Container( 
                            child: Column(
                              children: [
                                Image.network(
                                  product.img ?? '',
                                  width: 125,
                                  height: 125, 
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error); // Display an error icon, for example
                                  },
                                ),
                                SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${product.price} THB',
                                  style: TextStyle(
                                    color: Color(0xFFE5750E),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                left: 16, 
                top: 100, 
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xFFE5750E),
                  onPressed: () {
                    // Implement your action here
                  },
                ),
              ),
              Positioned(
                right: 16, 
                top: 100, 
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Color(0xFFE5750E),
                  onPressed: () {
                    // Implement your action here
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<ProductCategory>(
                  value: selectedCategory,
                  onChanged: (ProductCategory? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  elevation: 2,
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  underline: SizedBox(), // Removes the default underline
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Category'),
                    ),
                    DropdownMenuItem(
                      value: ProductCategory.All,
                      child: Text('All'),
                    ),
                    ...ProductCategory.values.where((category) => category != ProductCategory.All).map((ProductCategory category) {
                      return DropdownMenuItem<ProductCategory>(
                        value: category,
                        child: Text(_getCategoryText(category)),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: getFilteredProducts().length,
              itemBuilder: (BuildContext context, int index) {
                Product product = getFilteredProducts()[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[200],
                  elevation: 0.0,
                  child: GestureDetector(
                    onTap: () {
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
    );
  }

  String _getCategoryText(ProductCategory category) {
    switch (category) {
      case ProductCategory.Sport:
        return 'Sport';
      case ProductCategory.Fashion:
        return 'Fashion';
      case ProductCategory.Furniture:
        return 'Furniture';
      default:
        return '';
    }
  }

  String getCategoryString(ProductCategory? category) {
    switch (category) {
      case ProductCategory.Sport:
        return 'sport';
      case ProductCategory.Fashion:
        return 'fashion';
      case ProductCategory.Furniture:
        return 'furniture';
      default:
        return '';
    }
  }
}

enum ProductCategory {
  All,
  Sport,
  Fashion,
  Furniture,
}
