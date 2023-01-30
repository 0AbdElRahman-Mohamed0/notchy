import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:notchy/models/address_model.dart';
import 'package:notchy/models/name_model.dart';
import 'package:notchy/models/product_model.dart';
import 'package:notchy/models/user_model.dart';
import 'package:notchy/utils/vars.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiProvider {
  //Singleton
  ApiProvider._() {
    if (kDebugMode) _dio.interceptors.add(_logger);
  }

  static final ApiProvider instance = ApiProvider._();

  // Http Client
  final Dio _dio = Dio();

  // Logger
  final PrettyDioLogger _logger = PrettyDioLogger(
    requestBody: true,
    responseBody: true,
    error: true,
    requestHeader: true,
  );

  // Headers
  final Map<String, dynamic> _apiHeaders = <String, dynamic>{
    'Accept': 'application/json',
  };

  ////////////////////////////// END POINTS //////////////////////////////////////
  static const String _registerEndPoint = "users";
  static const String _loginEndPoint = "auth/login";
  static const String _productsEndPoint = "products";
  ////////////////////////////////////////////////////////////////////////

  Future<UserModel> register(UserModel user, String password) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_registerEndPoint', //TODO: user like register
      data: {
        ...user.toMap(),
        'password': password,
      },
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      user.id = response.data['id'];
      UserModel.saveToken('eyJhbGciOiJIUzI1NiIsInR'); // static token
      return user;
    } else {
      throw response.data;
    }
  }

  Future<UserModel> login(String username, String password) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_loginEndPoint',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      UserModel.saveToken(response.data['token']);

      final user = UserModel(
        username: 'Username',
        phone: '01234567890',
        email: 'test@email.com',
        id: 1,
        phoneCode: '+20',
        address: AddressModel(
          buildingNumber: 12,
          city: 'Alex',
          street: 'Street',
          zipcode: '213124',
        ),
        name: NameModel(
          firstName: 'AbdElRahman',
          lastName: 'Mohamed',
        ),
      );
      return user;
    } else {
      throw response.data;
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get(
      '${Connection.baseURL}$_productsEndPoint',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      final List<ProductModel> products = <ProductModel>[];
      for (var element in (response.data)) {
        products.add(ProductModel.fromMap(element));
      }
      return products;
    } else {
      throw response.data;
    }
  }

////////////////////////////////// UTILS ///////////////////////////////////////
  // Validating Request.
  bool _validResponse(int statusCode) => statusCode >= 200 && statusCode < 300;
}
