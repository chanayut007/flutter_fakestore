// Models
class Cart {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartProduct> products;

  Cart(
      {required this.id,
      required this.userId,
      required this.date,
      required this.products});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      products: (json['products'] as List)
          .map((p) => CartProduct.fromJson(p))
          .toList(),
    );
  }
}

class CartProduct {
  final int productId;
  final int quantity;

  CartProduct({required this.productId, required this.quantity});

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String username;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstname: json['name']['firstname'],
      lastname: json['name']['lastname'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}
