import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/ui/widget/product_card.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({Key? key, required this.category})
      : super(key: key);

  final String category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  _getData() async {
    try {
      await context
          .read<ProductsProvider>()
          .getCategoryProducts(widget.category);
    } on DioError catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().categoryProducts;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: products == null
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
              : GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 190 / 183,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
    );
  }
}
