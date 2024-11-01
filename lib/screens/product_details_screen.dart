import 'package:flutter/material.dart';
import 'package:shopping_app/services/api_service.dart';
import 'package:shopping_app/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final ApiService apiService = ApiService();

  ProductDetailsScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details",
            style: TextStyle(
                fontSize: 20 * scaleFactor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Product>(
        future: apiService.fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 16 * scaleFactor)));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(product.images,
                      width: double.infinity, fit: BoxFit.cover),
                  SizedBox(height: 20 * scaleFactor),
                  Text(product.title,
                      style: TextStyle(
                          fontSize: 22 * scaleFactor,
                          fontWeight: FontWeight.bold)),
                  Text(product.price,
                      style: TextStyle(
                          fontSize: 20 * scaleFactor, color: Colors.green)),
                  SizedBox(height: 20 * scaleFactor),
                  Text(product.description,
                      style: TextStyle(fontSize: 16 * scaleFactor)),
                ],
              ),
            );
          } else {
            return Center(
                child: Text("Product not found",
                    style: TextStyle(fontSize: 16 * scaleFactor)));
          }
        },
      ),
    );
  }
}
