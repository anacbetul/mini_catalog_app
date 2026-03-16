import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mini_catalog_app/models/product.dart';
import 'package:mini_catalog_app/constants/app_constants.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();

  factory ProductService() {
    return _instance;
  }

  ProductService._internal();

  List<Product>? _cachedProducts;

  void clearCache() {
    _cachedProducts = null;
  }

  Future<List<Product>> getAllProducts() async {
    try {
      if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
        return _cachedProducts!;
      }

      final response = await http
          .get(Uri.parse(AppConstants.productsUrl))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('API isteği zaman aşımına uğradı'),
          );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> productList = [];

        if (decoded is List) {
          productList = decoded;
        } else if (decoded is Map && decoded['data'] != null) {
          productList = decoded['data'];
        }

        _cachedProducts = productList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        return _cachedProducts!;
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      print('Ürün yükleme hatası: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final products = await getAllProducts();
      final lowerQuery = query.toLowerCase();

      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(lowerQuery) ||
                product.description.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      print('Arama hatası: $e');
      rethrow;
    }
  }

  List<Product> sortByPrice(List<Product> products, {bool ascending = true}) {
    final sorted = List<Product>.from(products);
    sorted.sort(
      (a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    return sorted;
  }
}
