import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/features/shop/screens/cart/widgets/cart_item.dart';
import 'package:ecommerce/features/shop/screens/cart/widgets/quantity_item.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class CCartItems extends StatefulWidget {
  final CartModel cart;
  final bool showButtonRemove;

  const CCartItems({
    super.key,
    required this.cart,
    required this.showButtonRemove,
  });

  @override
  State<CCartItems> createState() => _CCartItemsState();
}

class _CCartItemsState extends State<CCartItems> {
  void _incrementQuantity(int index) {
    setState(() {
      widget.cart.items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (widget.cart.items[index].quantity > 1) {
        widget.cart.items[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder:
          (_, __) => Divider(
            color: CColors.grey,
            thickness: 1,
            height: CSizes.defaultSpace,
          ),
      shrinkWrap: true,
      itemCount: widget.cart.items.length,
      itemBuilder:
          (_, index) => Column(
            children: [
              CCartItem(
                item: widget.cart.items[index],
                showButtonRemove: widget.showButtonRemove,
              ),
              const SizedBox(height: CSizes.spaceBtwItems),
              // Quantity
              widget.showButtonRemove
                  ? CQuantityItem(
                    quantity: widget.cart.items[index].quantity,
                    onIncrement: () => _incrementQuantity(index),
                    onDecrement: () => _decrementQuantity(index),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
    );
  }
}
