class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
