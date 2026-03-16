class AppConstants {
  static const String bannerUrl = 'https://wantapi.com/assets/banner.png';
  static const String productsUrl = 'https://wantapi.com/products.php';

  static const String appName = 'Mini Katalog';
  static const String appVersion = '1.0.0';

  static const String productListRoute = '/';
  static const String productDetailRoute = '/product-detail';
  static const String cartRoute = '/cart';

  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const int gridColumnsPhone = 2;
  static const int gridColumnsTablet = 3;
  static const double gridSpacing = 16.0;

  static const int minSearchLength = 1;
  static const int maxProductTitle = 100;

  static final String currencySymbol = '\$';
  static const String currencyCode = 'USD';

  static const String loadingMessage = 'Yükleniyor...';
  static const String errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
  static const String noProductsMessage = 'Ürün bulunamadı.';
  static const String addToCartSuccess = 'Sepete eklendi!';
  static const String removeFromCartSuccess = 'Sepetten kaldırıldı.';
}
