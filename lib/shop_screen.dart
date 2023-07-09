import 'package:flutter/material.dart';
import 'package:flutter_application_1/product_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String imageUrl;
  final String category;
  final String productName;
  final String productDescription;
  final int price;
  final double rating;

  Product({
    required this.imageUrl,
    required this.category,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print(json['thumbnail']);
    print(json['category']);
    print(json['title']);
    print(json['description']);
    print(json['price']);
    print(json['rating']);
    return Product(
      imageUrl: json['thumbnail'] as String,
      category: json['category'] as String,
      productName: json['title'] as String,
      productDescription: json['description'] as String,
      price: json['price'] as int,
      rating: json['rating'] as double,
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['products'];
    return jsonData.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('Failed to fetch products');
  }
}

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.58,
              ),
              primary: false,
              itemCount: products.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];

                return ProductCard(
                  imageUrl: product.imageUrl,
                  category: product.category,
                  productName: product.productName,
                  productDescription: product.productDescription,
                  price: product.price,
                  rating: product.rating,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
