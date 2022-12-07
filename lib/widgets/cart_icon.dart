import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/screen/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartIcon extends StatefulWidget {
  const CartIcon({Key? key}) : super(key: key);
  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  Color background = Colors.white;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const CartScreen(),
          ),
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30.0,
              ),
            ),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInitial) {
                cartCubit.getCart();
                return Positioned(
                  top: 5,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }
              if (state is CartLoaded && state.items.isNotEmpty) {
                return Positioned(
                  top: 5,
                  right: 0,
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(state.items.length.toString()),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
