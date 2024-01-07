import 'package:zero_2024_flutter/domain/subscription/subscription_domain_object.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_repository.dart';
import 'package:zero_2024_flutter/iap/iap_connection.dart';
import 'package:zero_2024_flutter/shared/result.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {

  SubscriptionRepositoryImpl();

  final List<String> _subscriptionsIDs = [
    "plan_a",
    "plan_b",
  ];

  @override
  Future<Result<SubscriptionDomainObject>> get() async {
    final instance = IAPConnection.instance;
    final response = await instance.queryProductDetails(_subscriptionsIDs.toSet());
    final list = response.productDetails;
    if (list.isNotEmpty) {
      final product = list.first;
      return Success(
        SubscriptionDomainObject(
          name: product.title,
          price: product.price,
          description: product.description,
          id: product.id,
        )
      );
    } else {
      return Failure("No subscription found");
    }
  }
}
