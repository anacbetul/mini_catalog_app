import 'package:mini_catalog_app/models/product.dart';
import 'package:mini_catalog_app/models/cart_item.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product, {int quantity = 1}) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int quantity) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    if (quantity <= 0) {
      removeFromCart(productId);
    } else {
      item.quantity = quantity;
    }
  }

  void increaseQuantity(int productId) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    item.quantity++;
  }

  void decreaseQuantity(int productId) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      removeFromCart(productId);
    }
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId).quantity;
    } catch (e) {
      return 0;
    }
  }

  void clearCart() {
    _items.clear();
  }

  int getTotalItems() {
    return _items.length;
  }
}
