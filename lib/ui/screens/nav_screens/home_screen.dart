import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/categories_provider.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/screens/category_products_screen.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/ui/widget/product_card.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _getData() async {
    try {
      await Future.wait({
        context.read<ProductsProvider>().getProducts(),
        context.read<CategoriesProvider>().getCategories(),
      });
    } on DioError catch (e) {
      showDialog(
        context: context,
        builder: (_) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;
    final categories = context.watch<CategoriesProvider>().categories;
    return products == null || categories == null
        ? const LoadingWidget()
        : products.isEmpty
            ? Center(
                child: Text(
                  'No Products',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : ListView(
                children: [
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Categories',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: categories.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CategoryProductsScreen(
                                category: categories[index]),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Text(
                            categories[index],
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Products',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 190 / 183,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: products
                        .map(
                          (product) => ChangeNotifierProvider<ProductProvider>(
                            create: (_) => ProductProvider(product),
                            child: const ProductCard(),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
  }
}
