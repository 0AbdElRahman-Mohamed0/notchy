import 'package:dio/dio.dart';

extension DioErrorExtensions on DioError {
  bool get is401 => response?.statusCode == 401;

  bool get is406 => response?.statusCode == 406;

  bool get is500 => response?.statusCode == 500;

  String get readableError {
    // No Response ? then No Server...
    if (response?.data == null) {
      return "server reach error";
    }

    if (is500) {
      return "server error";
    }

    // if response is String .. ex: 404
    if (response!.data.runtimeType == String) {
      // Url Not Found...
      if (response!.statusCode == 404) {
        return '404 error';
      }
      return '${response!.data}';
      // Else if Server Returned something..
    } else if (response!.data is Map<String, dynamic>) {
      if (response!.data['errors'] != null &&
          response!.data['errors'] is Map<String, dynamic>) {
        return '${response!.data['errors'].values.first.first}';
      }
      if (response!.data.values.first is List) {
        return '${response!.data.values.first.first}';
      }
      return '${response!.data.values.first}';
    }

    // IDK what the hell is this. so something weird happened;
    return 'server error';
  }
}
