import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class TestApiService {
  factory TestApiService(Dio dio, {String baseUrl}) = _TestApiService;

  @GET("/todos/1")
  Future<HttpResponse> fetchTestJson();
}
