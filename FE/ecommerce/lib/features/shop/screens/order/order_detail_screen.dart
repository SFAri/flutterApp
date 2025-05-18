import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserOrderDetailScreen extends StatefulWidget {
  Map<String, dynamic> order;

  UserOrderDetailScreen({super.key, required this.order});

  @override
  State<UserOrderDetailScreen> createState() => _UserOrderDetailScreenState();
}

class _UserOrderDetailScreenState extends State<UserOrderDetailScreen> {
  Map<String, dynamic>? shippingAddress;
  final ProfileController _profileController = ProfileController();

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initOrderData();
  }

  Future<void> initOrderData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? shippingAddressId = widget.order['shippingAddress'];

      if (shippingAddressId != null) {
        final Map<String, dynamic> fetchAddressData = await _profileController
            .fetchAddressDetail(shippingAddressId);
        if (mounted) {
          setState(() {
            isLoading = false;

            // Get  user address
            shippingAddress = fetchAddressData;

            errorMessage = null;
          });
        }
      }
    } catch (e) {
      print('Error during initOrderData: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _capitalize(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  Color _getStatusColor(String status, bool isDark) {
    final lowerStatus = status.toLowerCase();
    switch (lowerStatus) {
      case 'pending':
        return CColors.warning;
      case 'shipped':
        return CColors.info;
      case 'cancelled':
        return CColors.error;
      case 'delivered':
        return CColors.success;
      default:
        return isDark ? CColors.lightGrey : CColors.primary;
    }
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    TextStyle? valueStyle,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CSizes.xs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, size: 16, color: Colors.grey.shade600),
              if (icon != null) const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            value,
            style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    final String orderId = '[#${widget.order['_id'].substring(0, 8)}]';
    final String status = _capitalize(widget.order['status']);
    final DateTime createdAt = DateTime.parse(widget.order['createdAt']);
    final List<Map<String, dynamic>> items =
        (widget.order['items'] is List)
            ? List<Map<String, dynamic>>.from(widget.order['items'])
            : [];

    final double subtotal =
        (widget.order['subtotal'] as num?)?.toDouble() ?? 0.0;
    final Map<String, dynamic> couponData =
        (widget.order['coupon'] is Map<String, dynamic>)
            ? widget.order['coupon']
            : {};

    final double couponDiscount =
        (couponData['discountAmount'] as num?)?.toDouble() ?? 0.0;
    final double shippingFee =
        (widget.order['shippingFee'] as num?)?.toDouble() ?? 0.0;
    final double totalAmount = subtotal - couponDiscount + shippingFee;

    return Scaffold(
      appBar: CAppBar(
        title: Text(
          'Order #${orderId.substring(orderId.length - 5)}',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        showBackArrows: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(CSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Order Info
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: dark ? CColors.lightGrey : CColors.lightGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(CSizes.md),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Order ID:',
                              orderId,
                              icon: Icons.receipt,
                            ),
                            _buildInfoRow(
                              'Order Date:',
                              DateFormat(
                                'dd MMM yyyy, hh:mm a',
                              ).format(createdAt),
                              icon: Icons.calendar_today,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.local_shipping, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Order Status:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Chip(
                                  label: Text(status),
                                  backgroundColor: _getStatusColor(
                                    status,
                                    dark,
                                  ).withOpacity(0.1),
                                  labelStyle: TextStyle(
                                    color: _getStatusColor(status, dark),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _buildInfoRow(
                              'Payment Method:',
                              widget.order['paymentMethod']
                                  .toString()
                                  .toUpperCase(),
                              icon: Icons.payments,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: CSizes.spaceBtwSections),

                    /// Shipping Address
                    Text(
                      'Shipping Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: CSizes.spaceBtwItems),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: dark ? CColors.lightGrey : CColors.lightGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(CSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shippingAddress?['fullName'],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: CSizes.spaceBtwItems / 2),
                            Text(shippingAddress?['phone']),
                            Text(shippingAddress?['detailAddress']),
                            Text(
                              '${shippingAddress?['ward']}, ${shippingAddress?['district']}, ${shippingAddress?['province']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: CSizes.spaceBtwSections),

                    /// Items
                    Text(
                      'Order Items',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: CSizes.spaceBtwItems),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(height: CSizes.spaceBtwItems),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final num itemUnitPrice = item['unitPrice'];
                        final num itemDiscount = item['discountPerProduct'];
                        final num finalItemPrice = itemUnitPrice - itemDiscount;

                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: dark ? CColors.lightGrey : CColors.lightGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(CSizes.md),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                item['productName'],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Variant ID: ${item['variantId']}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    itemDiscount > 0
                                        ? 'Unit Price: ${CFormatFunction.formatCurrency(itemUnitPrice.toDouble())} (Discount: ${itemDiscount.toInt()} %)'
                                        : 'Unit Price: ${CFormatFunction.formatCurrency(itemUnitPrice.toDouble())}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Qty: ${item['quantity']}'),
                                  Text(
                                    CFormatFunction.formatCurrency(
                                      finalItemPrice.toDouble() *
                                          item['quantity'],
                                    ),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: CSizes.spaceBtwSections),

                    /// Summary
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: CSizes.spaceBtwItems),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: dark ? CColors.lightGrey : CColors.lightGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(CSizes.md),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Subtotal:',
                              CFormatFunction.formatCurrency(subtotal),
                            ),
                            _buildInfoRow(
                              'Coupon (${couponData['code']}):',
                              '-${CFormatFunction.formatCurrency(couponDiscount)}',
                              valueStyle: const TextStyle(
                                color: CColors.primary,
                              ),
                            ),
                            _buildInfoRow(
                              'Shipping Fee:',
                              CFormatFunction.formatCurrency(shippingFee),
                            ),
                            const Divider(height: CSizes.spaceBtwSections),
                            _buildInfoRow(
                              'Total Amount:',
                              CFormatFunction.formatCurrency(totalAmount),
                              valueStyle: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: CColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
