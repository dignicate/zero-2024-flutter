import 'dart:async';
import 'package:zero_2024_flutter/domain/resource.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_domain_object.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_repository.dart';
import 'package:zero_2024_flutter/shared/result.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

class SubscriptionUseCase {
  final SubscriptionRepository _subscriptionRepository;

  final _dataController = StreamController<Resource<SubscriptionDomainObject>>();

  SubscriptionUseCase({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository;

  Stream<Resource<SubscriptionDomainObject>> get resource => _dataController.stream;

  void fetch() {
    _dataController.add(const Resource.loading());

    _fetch().then((data) => {
      _dataController.add(data)
    }).catchError((error) => {
      _dataController.add(Resource.error(message: error.toString()))
    });
  }

  Future<Resource<SubscriptionDomainObject>> _fetch() async {
    try {
      Result result = await _subscriptionRepository.get();
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
