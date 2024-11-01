class Product {
  final String id;
  final String price;
  final String title;
  final String images;
  final double rating;
  final String description;

  Product({
    required this.id,
    required this.price,
    required this.title,
    required this.images,
    required this.rating,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'],
      title: json['title'],
      images: json['images'],
      rating: json['rating'].toDouble(),
      description: json['description'],
    );
  }
}
