import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.title, this.onTap, this.logout = false})
      : super(key: key);

  final String title;
  final Function()? onTap;
  final bool logout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: logout
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
        ),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
