import 'package:equatable/equatable.dart';

abstract class ProductDefectEvent extends Equatable {
  const ProductDefectEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDefects extends ProductDefectEvent {}
