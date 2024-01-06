import 'package:zero_2024_flutter/shared/result.dart';
import 'todo_domain_object.dart';

abstract class DummyRepository {
  Future<Result<TodoDomainObject>> get();
}
