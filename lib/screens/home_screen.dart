import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_new/controllers/cart_controller.dart';
import 'package:task_new/controllers/location_provider.dart';
import 'package:task_new/routes/app_routes.dart';
import 'package:task_new/utils/app_colors.dart';
import 'package:task_new/widgets/product_card.dart';

import '../controllers/products_controller.dart';
import '../models/product_model.dart'; // For state management with Riverpod

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(groceryHomeControllerProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _HeaderSection()),
        SliverToBoxAdapter(child: _CategorySelector()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Featured Products',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final Product product = controller.filteredProducts[index];
              return ProductCard(product: product);
            }, childCount: controller.filteredProducts.length),
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends ConsumerStatefulWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  @override
  ConsumerState<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<_HeaderSection> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    final searchValue = ref.read(groceryHomeControllerProvider).searchValue;
    searchController = TextEditingController(text: searchValue);

    Future(() => ref.read(locationProvider.notifier).getCurrentLocation());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _HeaderSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = ref.read(groceryHomeControllerProvider).searchValue;

    if (searchController.text != newValue) {
      searchController.text = newValue;
      searchController.selection = TextSelection.collapsed(
        offset: newValue.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartViewController = ref.watch(cartProvider);
    final locationViewController = ref.watch(locationProvider);
    final isLoading = ref.watch(
      locationProvider.select((val) => val.isLoading),
    );

    return Container(
      padding: const EdgeInsets.only(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        bottom: 20.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Location Row
          SizedBox(height: 10),
          GestureDetector(
            onTap: _showLocationOptions,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            locationViewController.location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.white,

                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Welcome and Cart Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  IconButton(
                    color: Colors.red,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      AppRoutes.goToCart(context);
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        cartViewController.itemCount.toString(),
                        style: const TextStyle(
                          color: AppColors.white,

                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: searchController,
            onChanged: (value) {
              ref
                  .read(groceryHomeControllerProvider.notifier)
                  .updateSearch(value);
            },
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref
                            .read(groceryHomeControllerProvider.notifier)
                            .clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Use Current Location'),
                onTap: () {
                  ref.read(locationProvider.notifier).updateLocation();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search Location'),
                onTap: () {
                  // TODO: Implement location search
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategorySelector extends ConsumerWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GroceryHomeController controller = ref.watch(
      groceryHomeControllerProvider,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 40.0, // Height for the horizontal list of chips
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: controller.categories.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductCategory category = controller.categories[index];
                final bool isSelected =
                    controller.selectedCategory == category.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ActionChip(
                    onPressed: () => ref
                        .read(groceryHomeControllerProvider)
                        .selectCategory(category.name),
                    backgroundColor: isSelected
                        ? AppColors.darkGreen
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.darkGreen
                            : Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    label: Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: isSelected ? Colors.white : AppColors.darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
