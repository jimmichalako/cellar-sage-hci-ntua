import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  const NavBarButton(
      {required this.iconPath,
      required this.label,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Column(
        children: [
          Image.asset(iconPath, width: 32, height: 32),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xffcac4d0),
            ),
          ),
        ],
      ),
    );
  }
}
