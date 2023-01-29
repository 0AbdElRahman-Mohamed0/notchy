import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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
  ////////////////////////////////////////////////////////////////////////

  Future<UserModel> register(UserModel user, String password) async {
    final response = await _dio.post(
      '${Connection.baseURL}$_registerEndPoint',
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
      return user;
    } else {
      throw response.data;
    }
  }

////////////////////////////////// UTILS ///////////////////////////////////////
  // Validating Request.
  bool _validResponse(int statusCode) => statusCode >= 200 && statusCode < 300;
}
