import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
