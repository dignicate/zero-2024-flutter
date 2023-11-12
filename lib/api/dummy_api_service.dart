import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zero_2024_flutter/data/dummy/todo_dto.dart';

part 'dummy_api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class DummyApiService {
  factory DummyApiService(Dio dio, {String baseUrl}) = _DummyApiService;

    @GET("/todos/1")
  Future<TodoDto> fetchTestJson();
}
