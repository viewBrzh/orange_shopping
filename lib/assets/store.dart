import 'product.dart';

class Store {
  final int id;
  final String name;
  final String image_url;
  final List<Product> productList;

  Store({
    required this.id,
    required this.name,
    required this.image_url,
    required this.productList,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    List<Product> productList = (json['productList'] as List<dynamic>)
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    return Store(
      id: json['id'],
      name: json['name'],
      image_url: json['image_url'],
      productList: productList,
    );
  }
}
