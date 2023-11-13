import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

@freezed
class Resource<T> with _$Resource<T> {
  const factory Resource.data({required T data}) = Data<T>;
  const factory Resource.loading() = Loading<T>;
  const factory Resource.error({required String message}) = Error<T>;
}
