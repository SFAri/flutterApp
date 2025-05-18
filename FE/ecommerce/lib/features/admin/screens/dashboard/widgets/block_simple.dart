import 'package:ecommerce/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';

class CBlockSimple extends StatelessWidget {
  const CBlockSimple({
    super.key,
    required this.title,
    required this.description,
    this.isMoney = false,
    this.isProfit = false,
  });

  final String title;
  final double description;
  final bool isMoney;
  final bool isProfit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(),
        borderRadius: BorderRadius.circular(10)
        // boxShadow: 
      ),
      padding: EdgeInsets.all(10),
      width: 150,
      height: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          Text(isMoney ? CFormatter.formatMoney(description.toString()) : description.toString(), style: TextStyle(color: isProfit? Colors.red : Colors.blue),)
        ],
      ),
    );
  }
}