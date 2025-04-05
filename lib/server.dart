// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_ui/models/user_model.dart';

class Server {
  static Server? _instance;
  late Dio dio;
  factory Server() {
    _instance ??= Server._internal();
    return _instance!;
  }

  Server._internal() {
    final domain = dotenv.env['DOMAIN'];
    if (domain == null) {
      throw Exception('DOMAIN environment variable is not set.');
    }

    dio = Dio(
      BaseOptions(
        baseUrl: domain,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        sendTimeout: Duration(seconds: 5),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.baseUrl}${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            '${e.response?.statusCode} Error Response: ${e.response?.data}',
          );

          return handler.next(e);
        },
      ),
    );
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      'auth/register',
      data: {'username': username, 'password': password},
    );
    print(response.data);
  }

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      'auth/login',
      data: {'username': username, 'password': password},
    );
    print(response.data);
    final token = response.data['token'];
    dio.options.headers['Authorization'] = 'Bearer $token';

    final userJson = response.data['user'];
    return UserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    final response = await dio.post('auth/logout');
    dio.options.headers.remove('Authorization');
    print(response.data);
  }
}
