import 'dart:async';
import 'package:zero_2024_flutter/domain/resource.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_domain_object.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

class SubscriptionUseCase {

  final _dataController = StreamController<Resource<SubscriptionDomainObject>>();

  SubsctionUseCase() {
  }

  void fetch() {
    _dataController.add(const Resource.loading());

    _fetch().then((data) => {
      _dataController.add(data)
    }).catchError((error) => {
      _dataController.add(Resource.error(message: error.toString()))
    });
  }

  Stream<Resource<SubscriptionDomainObject>> get resource => _dataController.stream;

  Future<Resource<SubscriptionDomainObject>> _fetch() async {
    try {
      return Resource.data(data: SubscriptionDomainObject(value: "value"));
    } catch (e, stackTrace) {
      sharedLogger.e("Error: $e\nstackTrace: $stackTrace");
      return Resource.error(message: "$e");
    }
  }

  void dispose() {
    _dataController.close();
  }
}
