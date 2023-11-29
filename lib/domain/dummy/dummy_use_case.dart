import 'dart:async';
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

  Stream<Resource<TodoDomainObject>> get resource => _dataController.stream;

  void fetch() {
    _dataController.add(const Resource.loading());

    _fetch().then((data) => {
      _dataController.add(data)
    }).catchError((error) => {
      _dataController.add(Resource.error(message: error.toString()))
    });
  }

  Future<Resource<TodoDomainObject>> _fetch() async {
    try {
      Result result = await _dummyRepository.get();
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

  void dispose() {
    _dataController.close();
  }
}
