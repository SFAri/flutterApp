import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class CCouponCode extends StatelessWidget {
  const CCouponCode({super.key, required this.dark, required this.onApply});

  final bool dark;
  final Function(String) onApply;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return CRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? CColors.grey : CColors.lightGrey,
      padding: const EdgeInsets.only(
        top: CSizes.sm,
        bottom: CSizes.sm,
        right: CSizes.sm,
        left: CSizes.md,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Have a promo code? Enter here',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {
                String coupon = controller.text.trim().toUpperCase();
                if (coupon.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a coupon code.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                onApply(coupon); // Send coupon code back
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: dark ? CColors.dark : CColors.lightGrey,
                backgroundColor: CColors.primary,
                side: BorderSide(color: CColors.primary),
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
