import 'package:zero_2024_flutter/shared/result.dart';
import 'subscription_domain_object.dart';

abstract class SubscriptionRepository {
  Future<Result<SubscriptionDomainObject>> get();
}