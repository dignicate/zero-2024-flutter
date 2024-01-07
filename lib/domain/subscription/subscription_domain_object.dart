import 'package:equatable/equatable.dart';

class SubscriptionDomainObject extends Equatable {
  final String name;
  final String price;
  final String description;
  final String id;

  const SubscriptionDomainObject({
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
