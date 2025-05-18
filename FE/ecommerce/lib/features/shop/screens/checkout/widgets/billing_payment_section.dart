import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

enum PaymentMethodType { credit_card, paypal, cod }

class CBillingPaymentSection extends StatefulWidget {
  final void Function(PaymentMethodType) onPaymentMethodSelected;

  const CBillingPaymentSection({
    super.key,
    required this.onPaymentMethodSelected,
  });

  @override
  State<CBillingPaymentSection> createState() => _CBillingPaymentSectionState();
}

class _CBillingPaymentSectionState extends State<CBillingPaymentSection> {
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.credit_card;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPaymentMethodSelected(_selectedPaymentMethod);
    });
  }

  Widget _buildPaymentOptionTile({
    required PaymentMethodType value,
    required String title,
    required String imagePath,
    required bool isDark,
  }) {
    return RadioListTile<PaymentMethodType>(
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (PaymentMethodType? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedPaymentMethod = newValue;
          });
          widget.onPaymentMethodSelected(newValue);
        }
      },
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      secondary: CRoundedContainer(
        width: 100,
        height: 50,
        backgroundColor:
            isDark ? CColors.lightGrey.withOpacity(0.1) : CColors.lightGrey,
        padding: const EdgeInsets.all(CSizes.sm),
        child: Image(image: AssetImage(imagePath), fit: BoxFit.contain),
      ),
      activeColor: CColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CSectorHeading(
          title: 'Payment Method',
          textColor: dark ? CColors.lightGrey : CColors.primary,
          padding: 0,
          showActionButton: false,
        ),
        const SizedBox(height: CSizes.spaceBtwItems / 3),
        _buildPaymentOptionTile(
          value: PaymentMethodType.credit_card,
          title: 'Credit/Debit Card',
          imagePath: 'assets/images/payments/visa.png',
          isDark: dark,
        ),

        _buildPaymentOptionTile(
          value: PaymentMethodType.paypal,
          title: 'PayPal',
          imagePath: 'assets/images/payments/paypal.png',
          isDark: dark,
        ),

        _buildPaymentOptionTile(
          value: PaymentMethodType.cod,
          title: 'Cash on Delivery',
          imagePath: 'assets/images/payments/cod.png',
          isDark: dark,
        ),
      ],
    );
  }
}
