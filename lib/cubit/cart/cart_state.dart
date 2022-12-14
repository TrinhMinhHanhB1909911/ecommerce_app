part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  CartLoaded({required this.items});
  final List<CartItem> items;
}

class CartDetail extends CartState {
  final ProductModel product;
  CartDetail(this.product);
}

class CartChange extends CartState {
  
} 