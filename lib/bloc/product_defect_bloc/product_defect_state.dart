import 'package:equatable/equatable.dart';

abstract class ProductDefectState extends Equatable {
  const ProductDefectState();

  @override
  List<Object> get props => [];
}

class ProductDefectInitial extends ProductDefectState {}

class ProductDefectLoading extends ProductDefectState {}

class ProductDefectLoaded extends ProductDefectState {
  final List<String> defects;
  static const String defaultDefect = 'Ürün Hatası Yok';

  const ProductDefectLoaded(this.defects);

  @override
  List<Object> get props => [defects];
}
class ProductDefectError extends ProductDefectState {
  final String message;

  const ProductDefectError(this.message);

  @override
  List<Object> get props => [message];
}