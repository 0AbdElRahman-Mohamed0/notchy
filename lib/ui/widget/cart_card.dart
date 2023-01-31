import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/cart_provider.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class CartCard extends StatefulWidget {
  const CartCard({Key? key}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final product = context.read<ProductProvider>().product;
    _quantity = product.quantity ?? 1;
    _getData();
  }

  _getData() async {
    try {
      await context.read<ProductProvider>().getSingleProduct();
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

  _deleteProduct() async {
    try {
      final product = context.read<ProductProvider>().product;
      await context.read<CartProvider>().deleteProduct(product.id ?? 0);
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
    final product = context.watch<ProductProvider>().product;
    return product.title == null
        ? const LoadingWidget()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title ?? '',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      const SizedBox(
                        height: 8,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            TextSpan(
                              text: 'EGP',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _quantity++;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFF28140),
                            ),
                          ),
                          const SizedBox(
                            width: 22,
                          ),
                          Text(
                            '$_quantity',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const SizedBox(
                            width: 22,
                          ),
                          InkWell(
                            onTap: () {
                              if (_quantity == 1) return;
                              _quantity--;
                              setState(() {});
                            },
                            child: const Icon(Icons.remove_circle_outline),
                          ),
                          const SizedBox(
                            width: 22,
                          ),
                          InkWell(
                            onTap: _deleteProduct,
                            child: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: product.image ?? '',
                  height: 80,
                  width: 100,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const LoadingWidget(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                ),
              ],
            ),
          );
  }
}
