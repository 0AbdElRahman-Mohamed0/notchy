import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:notchy/models/address_model.dart';
import 'package:notchy/models/cart_model.dart';
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
  static const String _usersEndPoint = "users";
  static const String _loginEndPoint = "auth/login";
  static const String _productsEndPoint = "products";
  static const String _categoriesEndPoint = "products/categories";
  static const String _categoryEndPoint = "products/category";
  static const String _cartEndPoint = "carts";
  ////////////////////////////////////////////////////////////////////////

  Future<UserModel> register(UserModel user, String password) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_usersEndPoint', //TODO: user like register
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

  Future<UserModel> updateProfile(UserModel user) async {
    final response = await _dio.put(
      '${Connection.baseURL}$_usersEndPoint/7',
      data: user.toMap(),
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${await UserModel.getToken}', // act as there is token
          ..._apiHeaders,
        },
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return UserModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<List<ProductModel>> getProducts(
      {Map<String, dynamic>? filters}) async {
    final response = await _dio.get(
      '${Connection.baseURL}$_productsEndPoint',
      queryParameters: filters,
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

  Future<List<String>> getCategories() async {
    final response = await _dio.get(
      '${Connection.baseURL}$_categoriesEndPoint',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      final List<String> categories = <String>[];
      for (var element in (response.data)) {
        categories.add(element);
      }
      return categories;
    } else {
      throw response.data;
    }
  }

  Future<List<ProductModel>> getCategoryProducts(String category,
      {Map<String, dynamic>? filters}) async {
    final response = await _dio.get(
      '${Connection.baseURL}$_categoryEndPoint/$category',
      queryParameters: filters,
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

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_productsEndPoint',
      data: product.toMap(),
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return ProductModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _dio.put(
      '${Connection.baseURL}$_productsEndPoint/${product.id}',
      data: product.toMap(),
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return ProductModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await _dio.delete(
      '${Connection.baseURL}$_productsEndPoint/$productId',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
    } else {
      throw response.data;
    }
  }

  Future<CartModel> addNewCart(CartModel cart) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_cartEndPoint',
      data: cart.toMap(),
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return CartModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<CartModel> updateCart(CartModel cart, {int? cartId}) async {
    final response = await _dio.put(
      '${Connection.baseURL}$_cartEndPoint/${cartId ?? cart.id}',
      data: cart.toMap(),
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return CartModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<ProductModel> getSingleProduct(int productId) async {
    final response = await _dio.get(
      '${Connection.baseURL}$_productsEndPoint/$productId',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return ProductModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<CartModel> getCart() async {
    final response = await _dio.get(
      '${Connection.baseURL}$_cartEndPoint/5',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
      return CartModel.fromMap(response.data);
    } else {
      throw response.data;
    }
  }

  Future<void> deleteCart(int cartId) async {
    final response = await _dio.delete(
      '${Connection.baseURL}$_cartEndPoint/$cartId',
      options: Options(
        headers: _apiHeaders,
      ),
    );
    if (_validResponse(response.statusCode!)) {
    } else {
      throw response.data;
    }
  }

////////////////////////////////// UTILS ///////////////////////////////////////
  // Validating Request.
  bool _validResponse(int statusCode) => statusCode >= 200 && statusCode < 300;
}
