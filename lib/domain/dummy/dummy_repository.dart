import 'todo_domain_object.dart';

abstract class DummyRepository {
  Future<TodoDomainObject> doTest();
}
