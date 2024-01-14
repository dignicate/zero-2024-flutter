import 'package:equatable/equatable.dart';

class SubscriptionDomainObject extends Equatable {
  final List<SubscriptionDomainObjectItem> list;

  const SubscriptionDomainObject({
    required this.list,
  });

  @override
  List<Object?> get props => [
    list,
  ];
}

class SubscriptionDomainObjectItem extends Equatable {
  final String name;
  final String price;
  final String description;
  final String id;

  const SubscriptionDomainObjectItem({
    required this.name,
    required this.price,
    required this.description,
    required this.id,
  });

  @override
  List<Object?> get props => [
    name,
    price,
    description,
    id,
  ];
}
