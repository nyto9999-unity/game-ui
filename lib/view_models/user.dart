import 'package:game_ui/models/user_model.dart';
import 'package:game_ui/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
part 'user.g.dart';

@riverpod
class User extends _$User {
  @override
  Future<UserModel?> build() async => null;

  Future<void> setUser({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = await Server().login(
        username: username,
        password: password,
      );

      state = AsyncValue.data(user);
    } on DioException catch (e) {
      state = AsyncValue.error(e.response?.data['message'], StackTrace.current);
    }
  }
}
