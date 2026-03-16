import 'package:flutter/material.dart';
import 'package:mini_catalog_app/models/product.dart';
import 'package:mini_catalog_app/constants/app_constants.dart';
import 'package:mini_catalog_app/constants/app_colors.dart';
import 'package:mini_catalog_app/constants/app_typography.dart';
import 'package:mini_catalog_app/services/product_service.dart';
import 'package:mini_catalog_app/services/cart_service.dart';
import 'package:mini_catalog_app/widgets/custom_app_bar.dart';
import 'package:mini_catalog_app/widgets/product_card.dart';
import 'package:mini_catalog_app/widgets/loading_widget.dart';
import 'package:mini_catalog_app/widgets/error_widget.dart' as custom_error;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  String _searchQuery = '';
  String _sortBy = 'Varsayılan';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final products = await _productService.getAllProducts();
    _allProducts = products;
    _applyFilters();
    return products;
  }

  void _applyFilters() {
    _filteredProducts = _allProducts;
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
    switch (_sortBy) {
      case 'Fiyata Göre (Düşük)':
        _filteredProducts = _productService.sortByPrice(
          _filteredProducts,
          ascending: true,
        );
        break;
      case 'Fiyata Göre (Yüksek)':
        _filteredProducts = _productService.sortByPrice(
          _filteredProducts,
          ascending: false,
        );
        break;
    }

    setState(() {});
  }

  void _onSearch(String value) {
    _searchQuery = value;
    _applyFilters();
  }

  void _onSortChanged(String sortOption) {
    _sortBy = sortOption;
    _applyFilters();
  }

  void _addToCart(Product product) {
    _cartService.addToCart(product);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi!'),
        duration: AppConstants.shortDuration,
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ürünleri Keşfedin',
        showBackButton: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, AppConstants.cartRoute);
                },
              ),
              if (_cartService.itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _cartService.itemCount.toString(),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _productsFuture = _loadProducts();
          });
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 4,
              child: Image.network(
                AppConstants.bannerUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: AppColors.greyLight);
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.greyLight);
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }

                  if (snapshot.hasError) {
                    return custom_error.ErrorWidget(
                      message: 'Ürünler yüklenirken hata oluştu',
                      onRetry: () {
                        setState(() {
                          _productsFuture = _loadProducts();
                        });
                      },
                    );
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearch,
                          decoration: InputDecoration(
                            hintText: 'Ürün adını yazın...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearch('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.defaultBorderRadius,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                        ),
                        child: Row(
                          children: [
                            _buildFilterDropdown(
                              label: 'Sıralama: $_sortBy',
                              options: [
                                'Varsayılan',
                                'Fiyata Göre (Düşük)',
                                'Fiyata Göre (Yüksek)',
                              ],
                              onChanged: _onSortChanged,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding,
                        ),
                        child: Text(
                          '${_filteredProducts.length} ürün bulundu',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      if (_filteredProducts.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.inbox,
                                  size: 64,
                                  color: AppColors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Ürün bulunamadı',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: AppConstants.gridColumnsPhone,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: AppConstants.gridSpacing,
                                  mainAxisSpacing: AppConstants.gridSpacing,
                                ),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppConstants.productDetailRoute,
                                    arguments: product,
                                  );
                                },
                                onAddToCart: () {
                                  _addToCart(product);
                                },
                              );
                            },
                          ),
                        ),
                      SizedBox(height: AppConstants.largePadding),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (BuildContext context) {
        return options.map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
