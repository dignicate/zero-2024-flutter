import 'package:zero_2024_flutter/api/dummy_api_service.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_repository.dart';
import 'package:zero_2024_flutter/domain/dummy/todo_domain_object.dart';
import 'package:zero_2024_flutter/data/dummy/todo_dto.dart';
import 'package:dio/dio.dart';
import 'package:zero_2024_flutter/shared/result.dart';

class DummyRepositoryImpl implements DummyRepository {
  final DummyApiService _apiService;

  DummyRepositoryImpl(this._apiService);

  Future<Result<TodoDomainObject>> get() async {
    try {
      final todoDto = await _apiService.fetchTestJson();
      return Success(todoDto.toDomain());
    } on DioException catch (e) {
      if (e.response != null) {
        return Failure(
            'API error: ${e.response!.statusCode} ${e.response!.data}');
      } else {
        return Failure('$e');
        // throw Exception('Dio error: $e');
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
