import 'package:flutter/material.dart';

class WFilterButton extends StatelessWidget {
  const WFilterButton({
    super.key,
    required this.icon,
    required this.label
  });

  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size(30, 20),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        foregroundColor: Colors.black,
        iconColor: Colors.amberAccent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)
        )
      ),
      onPressed: (){}, 
      child: Row(
        spacing: 5,
        children: [
          icon,
          Text(label),
        ],
      )
    );
  }
}