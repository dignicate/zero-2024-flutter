import 'package:in_app_purchase/in_app_purchase.dart';
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
      return Success(
        SubscriptionDomainObject(
          list: list.toDomain(),
        )
      );
    } else {
      return Failure("No subscription found");
    }
  }
}

extension _SubscriptionDtoExtension on List<ProductDetails> {
  List<SubscriptionDomainObjectItem> toDomain() {
    return map((e) =>
      SubscriptionDomainObjectItem(
        name: e.title,
        price: e.price,
        description: e.description,
        id: e.id,
      )
    ).toList();
  }
}
