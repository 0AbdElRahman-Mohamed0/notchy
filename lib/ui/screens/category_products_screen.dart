import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/screens/filter_screen.dart';
import 'package:notchy/ui/screens/search_delegate_screen.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/input_form_field.dart';
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

  Future<void> _showSearch() async {
    final products = context.read<ProductsProvider>().categoryProducts;

    await showSearch(
      context: context,
      delegate: SearchDelegateScreen(
        context: context,
        initialList: (products ?? []),
      ),
      query: "",
    );
  }

  _filterProducts(Map<String, dynamic> filters) async {
    try {
      await context
          .read<ProductsProvider>()
          .getCategoryProducts(widget.category, filters: filters);
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
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InkWell(
                              onTap: _showSearch,
                              child: const InputFormField(
                                enabled: false,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 11, bottom: 11),
                                  child: Icon(Icons.search),
                                ),
                                hintText: 'Search Product',
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final Map<String, dynamic>? filters =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FilterScreen(),
                              ),
                            );

                            if (filters == null) return;
                            _filterProducts(filters);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView(
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
                              (product) =>
                                  ChangeNotifierProvider<ProductProvider>(
                                create: (_) => ProductProvider(product),
                                child: const ProductCard(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
