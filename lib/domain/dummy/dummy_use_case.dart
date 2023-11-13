import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:zero_2024_flutter/domain/dummy/todo_domain_object.dart';
import 'package:zero_2024_flutter/domain/resource.dart';
import 'package:zero_2024_flutter/shared/result.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';
import 'dummy_repository.dart';

class DummyUseCase {
  final DummyRepository _dummyRepository;

  final _dataController = StreamController<Resource<TodoDomainObject>>();

  DummyUseCase({required DummyRepository dummyRepository})
      : _dummyRepository = dummyRepository;

  Stream<Resource<TodoDomainObject>> get data => _dataController.stream;

  void fetch() {
    _dataController.add(const Resource.loading());
  }

  Future<Resource<TodoDomainObject>> _fetch() async {
    try {
      Result result = (await _dummyRepository.get()) as Result;
      if (result is Success) {
        return Resource.data(data: result.value);
      } else if (result is Failure) {
        return Resource.error(message: result.message);
      } else {
        throw Exception("Unknown error");
      }
    } catch (e, stackTrace) {
      sharedLogger.e("Error: $e\nstackTrace: $stackTrace");
      return Resource.error(message: "$e");
    }
  }
}
