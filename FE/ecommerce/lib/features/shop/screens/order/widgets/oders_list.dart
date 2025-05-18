import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/features/shop/screens/checkout/controllers/order_controller.dart';
import 'package:ecommerce/features/shop/screens/order/order_detail_screen.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class COrderListItems extends StatefulWidget {
  const COrderListItems({super.key});

  @override
  State<COrderListItems> createState() => _COrderListItemsState();
}

class _COrderListItemsState extends State<COrderListItems> {
  final OrderController _orderController = OrderController();
  final DeepCollectionEquality deepEq = const DeepCollectionEquality();
  List<Map<String, dynamic>>? userOrders;
  bool isLoading = false;
  String? errorMessage;

  late String status;
  late String orderId;
  late DateTime dateOrder;
  late DateTime shippingDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context);
    if (!deepEq.equals(userOrders, settings.userOrder)) {
      setState(() {
        userOrders = settings.userOrder;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<Map<String, dynamic>> fetchedData =
          await _orderController.fetchOrderByUser();

      if (mounted) {
        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserOrder(fetchedData);

        setState(() {
          isLoading = false;
          userOrders = fetchedData;
        });
      }
    } catch (e) {
      errorMessage = e.toString();
      print("Error fetching orders: $errorMessage");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // if (errorMessage != null) {
    //   return Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(CSizes.defaultSpace),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             'Error loading orders: $errorMessage',
    //             style: TextStyle(color: Colors.red),
    //           ),
    //           const SizedBox(height: CSizes.spaceBtwItems),
    //           ElevatedButton(onPressed: loadData, child: const Text('Retry')),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    if (userOrders == null || userOrders!.isEmpty) {
      return const Center(child: Text('You have no orders yet.'));
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: userOrders!.length,
      separatorBuilder: (_, __) => SizedBox(height: CSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final order = userOrders![index];
        status = order['status']?.toString().toUpperCase() ?? 'N/A';
        orderId = order['_id']?.toString() ?? 'N/A';
        dateOrder = DateTime.parse(order['createdAt']);
        shippingDate = dateOrder.add(const Duration(days: 5));

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserOrderDetailScreen(order: order),
              ),
            );
          },
          child: CRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(CSizes.md),
            backgroundColor: dark ? CColors.dark : Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Section 1
                Row(
                  children: [
                    /// 1 - Icon
                    Icon(Iconsax.ship_copy),
                    SizedBox(width: CSizes.spaceBtwItems / 2),

                    /// 2 - Status & Date
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                              color: CColors.primary,
                              fontWeightDelta: 1,
                            ),
                          ),
                          Text(
                            CFormatFunction.formatDate(dateOrder),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),

                    /// 3 - Icon Button (Arrow)
                    Icon(Iconsax.arrow_right_3_copy, size: CSizes.iconSm),
                  ],
                ),
                const SizedBox(height: CSizes.spaceBtwItems),

                /// Section 2
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// 1 - Icon
                          Icon(Iconsax.tag_copy),
                          SizedBox(width: CSizes.spaceBtwItems / 2),

                          /// 2 - Order ID
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  '[#${orderId.length > 8 ? orderId.substring(0, 8) : orderId}]',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          /// 1 - Icon
                          Icon(Iconsax.calendar_1_copy),
                          SizedBox(width: CSizes.spaceBtwItems / 2),

                          /// 2 - Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ),
                                Text(
                                  CFormatFunction.formatDate(shippingDate),

                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
