import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_domain_object.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_repository.dart';
import 'package:zero_2024_flutter/iap/iap_connection.dart';
import 'package:zero_2024_flutter/shared/result.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {

  SubscriptionRepositoryImpl();

  final List<String> _subscriptionsIDs = [
    "plan_a",
    "plan_b",
  ];

  @override
  Future<Result<SubscriptionDomainObject>> get() async {
    final useDummyData = true;

    if (useDummyData) {
      return Success(_getDummyData());
    } else {
      final instance = IAPConnection.instance;
      final response = await instance.queryProductDetails(_subscriptionsIDs.toSet());
      sharedLogger.d("response: $response");
      sharedLogger.d("notFoundIDs: ${response.notFoundIDs}");
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

  SubscriptionDomainObject _getDummyData() {
    return const SubscriptionDomainObject(
      list: [
        SubscriptionDomainObjectItem(
          name: "plan_a",
          price: "¥100",
          description: "plan_aの説明",
          id: "plan_a",
        ),
        SubscriptionDomainObjectItem(
          name: "plan_b",
          price: "¥200",
          description: "plan_bの説明",
          id: "plan_b",
        ),
      ]
    );
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
