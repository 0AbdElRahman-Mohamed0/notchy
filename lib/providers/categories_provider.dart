import 'package:flutter/material.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class CategoriesProvider extends ChangeNotifier {
  final _api = ApiProvider.instance;
  List<String>? categories;

  Future<void> getCategories() async {
    categories = await _api.getCategories();
    notifyListeners();
  }
}
