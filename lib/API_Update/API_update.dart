import 'package:dio/dio.dart';

class APIUpdate {
  static Future<dynamic> updateResultEntry(
    
  {
    required String endpoint,
    required dynamic data
  }
  ) async {
    var dio = Dio();

    await dio.request(
      'http://62.171.174.119:35$endpoint',
      options: Options(
        method: 'POST',
      ),
      data: data
    );
  }
}
