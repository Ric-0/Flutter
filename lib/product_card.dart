import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String productName;
  final String productDescription;
  final int price;
  final double rating;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.category,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover, // Définit la façon dont l'image est redimensionnée pour remplir son conteneur
            ),
          ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            child: Text(category, textAlign: TextAlign.left),
          ),
          Container(
            padding: EdgeInsets.all(6),
            child: Text(
              productName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Container(
          //   padding: EdgeInsets.all(6),
          //   child: Row(
          //     children: const [
          //       Icon(Icons.star),
          //       Icon(Icons.star),
          //       Icon(Icons.star),
          //       Icon(Icons.star),
          //       Icon(Icons.star_outline),
          //     ],
          //   ),
          // ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            maxRating: 5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              // Handle the rating update if needed
            },
          ),
          Container(
            padding: EdgeInsets.all(6),
            child: Text(productDescription, textAlign: TextAlign.left),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price.toString() + '€',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  tooltip: 'Add to cart',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => const CartScreen())),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
