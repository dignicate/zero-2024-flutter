import 'package:equatable/equatable.dart';

class SubscriptionDomainObject extends Equatable {
  final String value;

  const SubscriptionDomainObject({
    required this.value,
  });

  @override
  List<Object?> get props => [
    value,
  ];
}
