import 'package:flutter/material.dart';
import 'package:notchy/models/user_model.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final _api = ApiProvider.instance;
  UserModel? user;

  Future<void> register(UserModel userModel, String password) async {
    user = await _api.register(userModel, password);
    notifyListeners();
  }
}
