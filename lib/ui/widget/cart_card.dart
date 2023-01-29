import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
  const CartCard({Key? key}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product name',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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
                          text: '123 ',
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
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
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
                        onTap: () {},
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
            Container(
              height: 80,
              width: 100,
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
