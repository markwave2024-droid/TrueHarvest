import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_new/controllers/whishlist_provider.dart';
import 'package:task_new/models/product_model.dart';
import 'package:task_new/routes/app_routes.dart';
import 'package:task_new/utils/app_colors.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistViewController = ref.read(wishlistProvider);
    return GestureDetector(
      onTap: () {
        AppRoutes.goToProductDetails(context, product);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) => const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final wishlist = ref.watch(wishlistProvider);
                          final wishlistController = ref.read(
                            wishlistProvider.notifier,
                          );

                          return IconButton(
                            icon: Icon(
                              wishlist.isInWishlist(product)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishlist.isInWishlist(product)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              wishlistController.toggleWishlist(product);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                product.category.name,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.grey),
              ),
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '₹ ${product.units[0].price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  Text(
                    product.units[0].unitName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
