import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HeaderRow extends StatelessWidget {
  HeaderRow(
      {Key? key,
      required this.title,
      this.hasMore = false,
      this.onPress,
      this.label})
      : super(key: key);
  final String title;
  final bool hasMore;
  final String? label;
  VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Visibility(
            visible: hasMore,
            child: IconButton(
              onPressed: onPress,
              icon: const Icon(CupertinoIcons.forward),
            ),
          ),
        ],
      ),
    );
  }
}
