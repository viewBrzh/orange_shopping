class UserCart {
  int id;
  int user_id;
  int product_id;

  UserCart(this.id, this.user_id, this.product_id);
  
  factory UserCart.fromJson(Map<String, dynamic> json) {
    return UserCart(
      json['id'],
      json['user_id'],
      json['product_id'],
    );
  }
}