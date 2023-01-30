import 'package:flutter/material.dart';
import 'package:notchy/models/product_model.dart';

export 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel product;
  ProductProvider(this.product);
}
