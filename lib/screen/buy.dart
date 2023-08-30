import 'package:flutter/material.dart';
import '../assets/product.dart';
import 'package:intl/intl.dart';
import 'package:orange_shopping/assets/apiUrl.dart';
import 'cart.dart';

class BuyScreen extends StatefulWidget {
  final List<Product> productL;

  const BuyScreen({required this.productL});

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  String shippingAddress = ''; // Initialize an empty shipping address

  double calculateTotalPrice() {
    double total = 0;
    for (Product product in widget.productL) {
      total += product.price;
    }
    return total;
  }

  String calculateShippingDate() {
    // Add your logic here to calculate the shipping date
    // For example, you can add a fixed number of days to the current date
    final currentDate = DateTime.now();
    final estimatedShippingDate = currentDate.add(Duration(days: 3));
    return DateFormat('yyyy-MM-dd').format(estimatedShippingDate);
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
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.grey,
                  onPressed: () {
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
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.productL.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = widget.productL[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[200],
                      elevation: 0.0,
                      child: GestureDetector(
                        onTap: () => {},
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
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Shipping Address',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          shippingAddress = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Estimated Shipping Date: ${calculateShippingDate()}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16), // Add spacing between text field and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price: ${calculateTotalPrice()} THB',
                  style: TextStyle(
                    color: Color(0xFFE5750E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the purchase button click here
                    // You can access the shipping address using 'shippingAddress'
                  },
                  child: Text(
                    'Purchase',
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
