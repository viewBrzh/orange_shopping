class Product {
  int id = 0;
  String name = '';
  String? img; // Change to nullable type
  int price;
  String cate = '';

  Product(this.id,this.name, this.img, this.price, this.cate);
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'],
      json['name'],
      json['image_url'],
      json['price'],
      json['category'],
    );
  }
}
