import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/ui/screens/edit_product_screen.dart';
import 'package:notchy/ui/screens/product_details_screen.dart';
import 'package:notchy/ui/widget/loading.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, this.myProduct = false}) : super(key: key);
  final bool myProduct;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final product = productProvider.product;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductProvider>.value(
            value: productProvider,
            child: widget.myProduct
                ? const EditProductScreen()
                : const ProductDetailsScreen(),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CachedNetworkImage(
              imageUrl: product.image ?? '',
              height: 80,
              width: double.infinity,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.title ?? '',
                      maxLines: 1,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${product.price ?? ''} EGP',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (product.rating?.rate != null)
                          Row(
                            children: [
                              Text(
                                '${product.rating?.rate ?? ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (widget.myProduct) ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Eidt product',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
