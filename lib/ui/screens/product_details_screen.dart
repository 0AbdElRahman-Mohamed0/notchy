import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notchy/models/cart_model.dart';
import 'package:notchy/providers/auth_provider.dart';
import 'package:notchy/providers/cart_provider.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  _addToCart() async {
    try {
      LoadingScreen.show(context);
      final product = context.read<ProductProvider>().product;
      final user = context.read<AuthProvider>().user;
      final cart = CartModel(
        date: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
        products: [product],
        userId: user?.id,
      );
      await context.read<CartProvider>().addCart(cart);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your product added to cart successfully.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } on DioError catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>().product;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      height: 140,
                      width: double.infinity,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const LoadingWidget(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              '${product.rating?.rate ?? ''}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      product.category ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${product.price ?? ''} ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          TextSpan(
                            text: 'EGP',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      product.description ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: CustomButton(
                onTap: _addToCart,
                title: 'Add To Cart',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
