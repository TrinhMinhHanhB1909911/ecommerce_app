import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/model/user_model.dart';

abstract class HomeState {}

class MainState extends HomeState {
  final BannerModel banners;
  final List<ProductModel> products;
  MainState({required this.banners, required this.products});
}

class FavoriteState extends HomeState {
  List<ProductModel> favoritedProducts;
  FavoriteState({required this.favoritedProducts});
}

class OrderState extends HomeState {
  List<OrderModel> orders;
  OrderState(this.orders);

  OrderState copyWith({
    List<OrderModel>? orders,
  }) {
    return OrderState(
      orders ?? this.orders,
    );
  }
}

class HistoryState extends HomeState {
  List<OrderModel> historyOrders;
  HistoryState(this.historyOrders);
}

class AccountState extends HomeState {
  final UserModel user;
  AccountState(this.user);
}

class LogoutState extends HomeState {}

class LoadingState extends HomeState {}

class InitialState extends HomeState {}

class ProductDetail extends HomeState {
  final ProductModel product;
  ProductDetail(this.product);
}

class CheckCartState extends HomeState {}

class Nav extends HomeState {
  final int index;
  Nav([this.index = 0]);
}

class GoToTopScreen extends HomeState {}
