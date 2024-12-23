import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

class NavigationListItem extends StatelessWidget{
  final String title;
  final VoidCallback onPressed;

  const NavigationListItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            blurRadius: 2,
          )
        ]
      ),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        )
      )
      )
    );
  }
}

class NavigationSubListItem extends StatelessWidget{
  final String title;
  final VoidCallback onPressed;

  const NavigationSubListItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            blurRadius: 2,
          )
        ]
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w.toDouble()),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        )
      )
      )
    );
  }
}