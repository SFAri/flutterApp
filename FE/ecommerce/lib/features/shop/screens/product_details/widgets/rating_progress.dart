import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class WRatingProgress extends StatelessWidget {
  const WRatingProgress({
    super.key,
    required this.label,
    required this.progress
  });

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 30,
          height: 20,
          child: Row(
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.star, size: 18),
            ],
          ),
        ),
        SizedBox(
          width: CDeviceUtils.getScreenWidth(context) * 0.45,                          
          child: LinearProgressIndicator(
            value: progress/100,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(
          width: 30,
          height: 20,
          child: Text('${progress.toInt()}%', textAlign: TextAlign.end,)
        )
      ],
    );
  }
}