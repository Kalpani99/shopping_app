import 'package:flutter/material.dart';
import 'package:shopping_app/services/api_service.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  final List<String> categories = [
    "All",
    "Tech & Gadget",
    "Fashion",
    "Home & Care"
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Products",
          style: TextStyle(
            fontSize: 20 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            height: 50 * scaleFactor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor),
                    child: Chip(
                      label: Text(category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: apiService.fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    padding: EdgeInsets.all(8.0 * scaleFactor),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4,
                      crossAxisSpacing: 10.0 * scaleFactor,
                      mainAxisSpacing: 10.0 * scaleFactor,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12 * scaleFactor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12 * scaleFactor),
                                  ),
                                  child: Image.network(
                                    product.images,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image,
                                          size: 50 * scaleFactor);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0 * scaleFactor),
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 16 * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0 * scaleFactor),
                                child: Text(
                                  product.price,
                                  style: TextStyle(
                                    fontSize: 14 * scaleFactor,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0 * scaleFactor),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16 * scaleFactor,
                                    ),
                                    SizedBox(width: 4 * scaleFactor),
                                    Text(
                                      "${product.rating}",
                                      style: TextStyle(
                                        fontSize: 12 * scaleFactor,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text("No products available",
                          style: TextStyle(fontSize: 16 * scaleFactor)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
