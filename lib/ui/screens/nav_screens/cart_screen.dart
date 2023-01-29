import 'package:flutter/material.dart';
import 'package:notchy/ui/widget/cart_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CartCard(),
                    const SizedBox(
                      height: 12,
                    ),
                    const CartCard(),
                    const SizedBox(
                      height: 12,
                    ),
                    const CartCard(),
                    const SizedBox(
                      height: 12,
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).cardColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
