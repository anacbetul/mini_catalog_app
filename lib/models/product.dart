class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String image;
  final double price;
  final String? currency;
  final Map<String, dynamic>? specs;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.image,
    required this.price,
    this.currency,
    this.specs,
    this.quantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double price = 0.0;
    if (json['price'] != null) {
      String priceStr = json['price'].toString();
      // Remove all non-numeric characters except decimal point
      priceStr = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
      price = double.tryParse(priceStr) ?? 0.0;
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      tagline: json['tagline'] ?? 'Unknown',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: price,
      currency: json['currency'],
      specs: json['specs'] is Map
          ? json['specs'] as Map<String, dynamic>
          : null,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'image': image,
      'price': price,
      'currency': currency,
      'specs': specs,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? image,
    double? price,
    String? category,
    double? rating,
    String? currency,
    Map<String, dynamic>? specs,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name,
      tagline: tagline,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      specs: specs ?? this.specs,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, tagline: $tagline, price: $price, quantity: $quantity)';
  }
}
