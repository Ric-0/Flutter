import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts().then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    }).catchError((error) {
      print('Error fetching products: $error');
    });
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/carts'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> cartDataList = jsonData['carts'];
      final cartData = cartDataList[Random().nextInt(cartDataList.length)];
      final List<dynamic> productsData = cartData['products'];
      return productsData.map((productData) => Product.fromJson(productData)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  void incrementQuantity(int index) {
    setState(() {
      products[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (products[index].quantity > 1) {
        products[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalQuantity =
        products.fold(0, (sum, product) => sum + product.quantity);
    double totalPrice = products.fold(
        0, (sum, product) => sum + (product.price * product.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // Ajout d'un espace supérieur
            Align(
              alignment: Alignment.centerRight, // Aligner le titre à droite
              child: Text(
                'Mon panier',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.right, // Alignement du texte à droite
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    'Nombre d\'articles: $totalQuantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Prix total: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            for (int i = 0; i < products.length; i++)
              ProductCard(
                product: products[i],
                incrementQuantity: () => incrementQuantity(i),
                decrementQuantity: () => decrementQuantity(i),
              ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final ImageProvider image;
  final String productName;
  final double price;
  int quantity;

  Product({
    required this.image,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print(json);
    return Product(
      image: AssetImage('images/profil.png'),
      productName: json['title'] as String,
      price: json['price'].toDouble() as double,
      quantity: json['quantity'] as int,
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;

  const ProductCard({
    Key? key,
    required this.product,
    required this.incrementQuantity,
    required this.decrementQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            // Image réelle du produit
            child: Image(image: product.image),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Text(
                  'Prix: \$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: decrementQuantity,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${product.quantity}'),
                    IconButton(
                      onPressed: incrementQuantity,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Total: \$${(product.price * product.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
