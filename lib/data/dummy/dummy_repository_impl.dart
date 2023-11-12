import 'package:zero_2024_flutter/api/dummy_api_service.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_repository.dart';
import 'package:zero_2024_flutter/domain/dummy/todo_domain_object.dart';
import 'package:zero_2024_flutter/data/dummy/todo_dto.dart';
import 'package:dio/dio.dart';

class DummyRepositoryImpl implements DummyRepository {
  final DummyApiService _apiService;

  DummyRepositoryImpl(this._apiService);

  Future<TodoDomainObject> doTest() async {
    try {
      final todoDto = await _apiService.fetchTestJson(); // 直接TodoDtoを受け取る
      return todoDto.toDomain(); // 変換してドメインオブジェクトを返す
    } on DioException catch (e) {
      // DioErrorを捕捉して処理
      if (e.response != null) {
        // エラーレスポンスがある場合はその情報を使う
        throw Exception('API error: ${e.response!.statusCode} ${e.response!.data}');
      } else {
        // エラーレスポンスがない場合はその他のエラー情報を使う
        throw Exception('Dio error: $e');
      }
    }
  }
}

extension _TodoDtoExtension on TodoDto {
  TodoDomainObject toDomain() {
    return TodoDomainObject(
      userId: this.userId,
      id: this.id,
      title: this.title,
      completed: this.completed,
    );
  }
}
