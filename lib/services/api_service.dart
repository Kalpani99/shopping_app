import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/product.dart';

class ApiService {
  static const String productsUrl =
      "https://api.npoint.io/a907f54f4d95e9e31711";
  static const String productDetailsUrl =
      "https://api.npoint.io/7fe4c3d8d85298ece626";

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductDetails(String id) async {
    try {
      final response = await http.get(Uri.parse(productDetailsUrl));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load product details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      rethrow;
    }
  }
}
