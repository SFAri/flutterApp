import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/features/shop/screens/product_details/product_detail.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/icons/circular_icon.dart';
import 'package:ecommerce/common/widgets/images/rounded_image.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

import 'package:ecommerce/features/shop/screens/cart/models/Product.dart';

class CCartItem extends StatefulWidget {
  final Product item;
  final CartModel cart;
  final bool showButtonRemove;

  const CCartItem({
    super.key,
    required this.item,
    required this.cart,
    this.showButtonRemove = true,
  });

  @override
  State<CCartItem> createState() => _CCartItemState();
}

class _CCartItemState extends State<CCartItem> {
  void _confirmationRemove(Product item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Product: ${item.name}"),
          content: const Text(
            'Are you sure you want to remove this product from the cart?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  widget.cart.remove(item);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _handleVariantProps(Product item) {
    late String variantProps;
    print("type: ${item.variant.type}");
    switch (item.variant.type) {
      case "Laptop":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nScreenSize: ${item.variant.specs.screenSize.toString()}";
        break;
      case "Desktop":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nScreenSize: ${item.variant.specs.screenSize.toString()}";
        ;
        break;
      case "RAM":
        variantProps =
            "RAM: ${item.variant.specs.ram.toString()} \nStorage: ${item.variant.specs.storage.toString()}";
        break;
      case "GPU":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nGPU: ${item.variant.specs.gpu.toString()}";
        ;
        break;
      case "SSD":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nStorage: ${item.variant.specs.storage.toString()}";
        break;
      case "HDD":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nStorage: ${item.variant.specs.storage.toString()}";
        break;
      case "Motherboard":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nSocket: ${item.variant.specs.socket.toString()} \nChipset: ${item.variant.specs.chipset.toString()}";
        break;
      case "Monitor":
        variantProps =
            "SKU: ${item.variant.variantId.toString()} \nScreenSize: ${item.variant.specs.screenSize.toString()}";
        break;
      default:
        variantProps = "SKU: ${item.variant.variantId.toString()} ";
    }
    return variantProps;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Image
        CRoundedImage(
          imageUrl: widget.item.image,
          isNetworkImage: true,
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(CSizes.sm),
          backgroundColor:
              CHelperFunctions.isDarkMode(context)
                  ? CColors.grey
                  : CColors.lightGrey,
        ),
        SizedBox(width: CSizes.spaceBtwItems),
        // Title, Price, Quantity
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetail(id: widget.item.id),
                          ),
                        );
                      },
                      child: Text(
                        widget.item.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Remove Button
                  widget.showButtonRemove
                      ? TCircularIcon(
                        icon: Icons.delete_outline,
                        width: 32,
                        height: 32,
                        color: CColors.dark,
                        backgroundColor:
                            CHelperFunctions.isDarkMode(context)
                                ? CColors.grey
                                : CColors.lightGrey,
                        onPressed: () {
                          _handleVariantProps(widget.item);
                          _confirmationRemove(widget.item);
                        },
                      )
                      : Text(
                        "Qty: ${widget.item.quantity}",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CColors.primary,
                        ),
                      ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Variant: ',
                  //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //     color:
                  //         CHelperFunctions.isDarkMode(context)
                  //             ? CColors.textWhite
                  //             : CColors.dark,
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      // Show color picker or dropdown dialog here
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              CHelperFunctions.isDarkMode(context)
                                  ? CColors.textWhite
                                  : CColors.dark,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Flexible(
                        child: Text(
                          _handleVariantProps(widget.item),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                CHelperFunctions.isDarkMode(context)
                                    ? CColors.textWhite
                                    : CColors.dark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                CFormatFunction.formatCurrency(
                  CPricingCalculator.calculateDiscount(
                    widget.item.variant.salePrice,
                    widget.item.discount,
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: CColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CFormatFunction.formatCurrency(widget.item.variant.salePrice),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color:
                      CHelperFunctions.isDarkMode(context)
                          ? CColors.textWhite.withValues(alpha: 0.5)
                          : CColors.dark.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
