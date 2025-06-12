import 'dart:convert';
import 'package:cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Main Cart Screen
class CartScreen extends StatefulWidget {
  final String baseUrl;
  const CartScreen({Key? key, this.baseUrl = 'https://fakestoreapi.com'})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<UserCartData>> _userCartDataFuture;

  @override
  void initState() {
    super.initState();
    _userCartDataFuture = fetchUserCartData();
  }

  Future<List<Cart>> fetchCarts() async {
    final response = await http.get(Uri.parse('${widget.baseUrl}/carts'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Cart.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load carts');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response =
        await http.get(Uri.parse('${widget.baseUrl}/users/$userId'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Product> fetchProduct(int productId) async {
    final response =
        await http.get(Uri.parse('${widget.baseUrl}/products/$productId'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<UserCartData>> fetchUserCartData() async {
    final carts = await fetchCarts();

    // Group carts by userId
    final Map<int, List<Cart>> userCarts = {};
    for (var cart in carts) {
      userCarts.putIfAbsent(cart.userId, () => []).add(cart);
    }

    List<UserCartData> result = [];
    for (var entry in userCarts.entries) {
      final user = await fetchUser(entry.key);

      // Flatten all products for this user
      final List<CartProduct> allProducts =
          entry.value.expand((c) => c.products).toList();

      // Group products by productId and sum quantity
      final Map<int, int> productQuantities = {};
      for (var p in allProducts) {
        productQuantities[p.productId] =
            (productQuantities[p.productId] ?? 0) + p.quantity;
      }

      // Fetch product details
      List<UserCartProduct> userCartProducts = [];
      for (var pq in productQuantities.entries) {
        final product = await fetchProduct(pq.key);
        userCartProducts.add(UserCartProduct(
          product: product,
          quantity: pq.value,
        ));
      }

      result.add(UserCartData(
        user: user,
        products: userCartProducts,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart List'),
        centerTitle: MediaQuery.of(context).size.width <= 600,
      ),
      body: FutureBuilder<List<UserCartData>>(
        future: _userCartDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final userCartData = snapshot.data!;
          return ListView.builder(
            itemCount: userCartData.length,
            itemBuilder: (context, index) {
              final userData = userCartData[index];
              final total = userData.products.fold<double>(
                0,
                (sum, p) => sum + p.product.price * p.quantity,
              );
              return Card(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 2,
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.secondary,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  title: Text(
                    '${userData.user.firstname} ${userData.user.lastname}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    userData.user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    ...userData.products.map((p) => ListTile(
                          leading: Image.network(p.product.image,
                              width: 40, height: 40),
                          title: Text(p.product.title),
                          subtitle: Text('Quantity: ${p.quantity}'),
                          trailing: Text(
                              '\$${(p.product.price * p.quantity).toStringAsFixed(2)}'),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Helper classes for grouping
class UserCartData {
  final User user;
  final List<UserCartProduct> products;

  UserCartData({required this.user, required this.products});
}

class UserCartProduct {
  final Product product;
  final int quantity;

  UserCartProduct({required this.product, required this.quantity});
}
