import 'package:ecommerce/utils/helpers/helper_functions.dart';
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
  final Map<int, bool> _outOfStockStatus = {};

  void _confirmationDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Product: ${widget.cart.items[index].name}"),
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
                  widget.cart.remove(widget.cart.items[index]);
                  _outOfStockStatus.remove(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _incrementQuantity(int index) {
    setState(() {
      widget.cart.incrementQuantity(widget.cart.items[index]);
      final currentQty = widget.cart.items[index].quantity;
      final maxQty = widget.cart.items[index].variant.inventory;

      if (currentQty > maxQty) {
        widget.cart.decrementQuantity(widget.cart.items[index]);

        CHelperFunctions.showAlert(
          'Out of stock',
          'You cannot add more than $maxQty items of this product',
          context: context,
        );
        _outOfStockStatus[index] = true;
      } else {
        _outOfStockStatus[index] = false;
      }
    });
  }

  void _decrementQuantity(int index) {
    final currentQty = widget.cart.items[index].quantity;
    if (currentQty > 1) {
      setState(() {
        widget.cart.decrementQuantity(widget.cart.items[index]);
        _outOfStockStatus[index] = false;
      });
    } else {
      _confirmationDelete(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
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
                cart: widget.cart,
                showButtonRemove: widget.showButtonRemove,
              ),
              const SizedBox(height: CSizes.spaceBtwItems),
              widget.showButtonRemove
                  ? CQuantityItem(
                    quantity: widget.cart.items[index].quantity,
                    isOutStock: _outOfStockStatus[index] ?? false,
                    onIncrement: () => _incrementQuantity(index),
                    onDecrement: () => _decrementQuantity(index),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
    );
  }
}
