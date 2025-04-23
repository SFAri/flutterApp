import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(CImages.avatar),
                    ),
                    Text('Admin'),
                
                  ],
                )
              ],
            ),

            // Main board
            
            // 1. Filter row:
            Wrap(
              children: [

              ],
            ),

            // 2. Simple dashboard wrap
            Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              children: [
                CBlockSimple(title: 'Total users',description: 250),
                CBlockSimple(title: 'Total orders',description: 10),
                CBlockSimple(title: 'Total revenues',description: 880000, isMoney: true,),
                CBlockSimple(title: 'Overall profit',description: 250000, isMoney: true, isProfit: true,)
              ],
            )

            // 3. Advanced dashboard: 1 pie graph, 1 line graph + bar graph

          ],
        ),
      ),
    );
  }
}

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
          Text(isMoney ? '${description} VND' : description.toString(), style: TextStyle(color: isProfit? Colors.red : Colors.blue),)
        ],
      ),
    );
  }
}