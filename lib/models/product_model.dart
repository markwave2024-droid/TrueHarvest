import 'package:task_new/utils/app_constants.dart';

class Product {
  final String id;
  final CategoryType category;
  final String name;
  final String imageUrl;
  final bool isFavorite;

  final String description;
  final List<String> features;
  final List<ProductUnit> units;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.imageUrl,
    required this.isFavorite,
    required this.description,
    required this.features,
    required this.units,
  });

  /// Creates a copy of this [Product] with the given fields replaced with new values.
  Product copyWith({bool? isFavorite}) {
    return Product(
      id: id,
      category: category,
      description: description,
      features: features,
      name: name,
      imageUrl: imageUrl,
      units: units,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// Custom Colors

/// Represents a single grocery product.

/// Represents a product category.
class ProductCategory {
  final String name;
  ProductCategory({required this.name});
}

class ProductUnit {
  final String unitName;
  final double price;

  ProductUnit({required this.unitName, required this.price});
}
