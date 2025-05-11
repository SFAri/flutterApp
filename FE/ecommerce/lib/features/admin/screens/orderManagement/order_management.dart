// import 'package:ecommerce/common/widgets/appbar/appbar.dart';
// import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
// // import 'package:ecommerce/common/widgets/layouts/rounded_container.dart';
// import 'package:ecommerce/features/admin/main.dart';
// // import 'package:ecommerce/features/admin/screens/orderManagement/order_detail.dart';
// // import 'package:ecommerce/features/admin/models/order.dart';
// import 'package:ecommerce/utils/constants/colors.dart';
// import 'package:ecommerce/utils/constants/sizes.dart';
// import 'package:ecommerce/utils/helpers/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// class OrderManagementScreen extends StatefulWidget { const OrderManagementScreen({super.key});
//
// @override State createState() => _OrderManagementScreenState(); }
//
// class _OrderManagementScreenState extends State { final List orders = [ Order( id: 1, userId: 'U001', userName: 'John Doe', userEmail: 'john.doe@example.com', userPhone: '123-456-7890', items: [ OrderItem( productId: 1, productName: 'Laptop Lenovo ThinkPad', variationId: 1, variationDetails: 'Color: Black, RAM: 16GB', price: 1200.0, quantity: 1, ), ], total: 1200.0, status: 'Pending', orderDate: DateTime(2025, 5, 1), couponCode: 'SAVE20', couponValue: 20.0, ), Order( id: 2, userId: 'U002', userName: 'Jane Smith', userEmail: 'jane.smith@example.com', userPhone: '987-654-3210', items: [ OrderItem( productId: 2, productName: 'Wireless Mouse Logitech', variationId: 2, variationDetails: 'Color: White', price: 50.0, quantity: 2, ), ], total: 100.0, status: 'Shipped', orderDate: DateTime(2025, 5, 2), deliveryDate: DateTime(2025, 5, 5), ), ];
//
// String? selectedStatus = 'All'; final TextEditingController searchController = TextEditingController();
//
// Future _showDialog(BuildContext context, String title, Widget content, VoidCallback acceptFunction) { return showDialog( context: context, builder: (BuildContext context) { return DialogForm(title: title, widgets: content, acceptFunction: acceptFunction); }, ); }
//
// @override Widget build(BuildContext context) { final dark = CHelperFunctions.isDarkMode(context); final filteredOrders = selectedStatus == 'All' ? orders : orders.where((order) => order.status == selectedStatus).toList();
//
// // Lọc thêm theo tìm kiếm
// final searchQuery = searchController.text.toLowerCase();
// final displayedOrders = searchQuery.isEmpty
//     ? filteredOrders
//     : filteredOrders.where((order) =>
// order.userName.toLowerCase().contains(searchQuery) ||
//     order.id.toString().contains(searchQuery)).toList();
//
// return Scaffold(
//   appBar: CAppBar(
//     showBackArrows: true,
//     title: Text(
//       'Order Management',
//       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     ),
//   ),
//   body: Padding(
//     padding: const EdgeInsets.all(CSizes.defaultSpace),
//     child: Column(
//       children: [
//         // Filter Row
//         Wrap(
//           direction: Axis.horizontal,
//           alignment: WrapAlignment.start,
//           crossAxisAlignment: WrapCrossAlignment.center,
//           spacing: CSizes.spaceBtwItems,
//           runSpacing: CSizes.spaceBtwItems,
//           children: [
//             // Search Bar
//             SizedBox(
//               width: 250,
//               child: TextFormField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search by name or ID',
//                   prefixIcon: const Icon(Iconsax.search_normal_copy),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(CSizes.borderRadiusMd),
//                   ),
//                 ),
//                 onChanged: (value) => setState(() {}),
//               ),
//             ),
//             // Status Filter
//             SizedBox(
//               width: 200,
//               child: DropdownButtonFormField<String>(
//                 value: selectedStatus,
//                 decoration: InputDecoration(
//                   labelText: 'Status',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(CSizes.borderRadiusMd),
//                   ),
//                 ),
//                 items: [
//                   'All',
//                   'Pending',
//                   'Processing',
//                   'Shipped',
//                   'Delivered',
//                   'Cancelled',
//                 ].map((status) {
//                   return DropdownMenuItem<String>(
//                     value: status,
//                     child: Text(status),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedStatus = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: CSizes.spaceBtwSections),
//         // Order List
//         Expanded(
//           child: ListView.separated(
//             shrinkWrap: true,
//             itemCount: displayedOrders.length,
//             separatorBuilder: (_, __) => const SizedBox(height: CSizes.spaceBtwItems),
//             itemBuilder: (_, index) {
//               final order = displayedOrders[index];
//               return CRoundedContainer(
//                 showBorder: true,
//                 padding: const EdgeInsets.all(CSizes.md),
//                 backgroundColor: dark ? CColors.dark : Colors.white,
//                 child: InkWell(
//                   onTap: () {
//                     streamController.add(OrderDetailScreen(order: order));
//                   },
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Section 1: Status and Date
//                       Row(
//                         children: [
//                           const Icon(Iconsax.ship_copy, color: CColors.primary),
//                           const SizedBox(width: CSizes.spaceBtwItems / 2),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   order.status,
//                                   style: Theme.of(context).textTheme.bodyLarge!.apply(
//                                     color: CColors.primary,
//                                     fontWeightDelta: 1,
//                                   ),
//                                 ),
//                                 Text(
//                                   order.orderDate.toString().substring(0, 10),
//                                   style: Theme.of(context).textTheme.titleMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               _showDialog(
//                                 context,
//                                 'Delete Order',
//                                 Text('Are you sure you want to delete order #${order.id}?'),
//                                     () {
//                                   setState(() {
//                                     orders.remove(order);
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Order deleted')),
//                                   );
//                                 },
//                               );
//                             },
//                             icon: const Icon(Iconsax.trash_copy, color: CColors.error),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: CSizes.spaceBtwItems),
//                       // Section 2: Order ID and Customer
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 const Icon(Iconsax.tag_copy),
//                                 const SizedBox(width: CSizes.spaceBtwItems / 2),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Order ID',
//                                         style: Theme.of(context).textTheme.labelMedium,
//                                       ),
//                                       Text(
//                                         '#${order.id}',
//                                         style: Theme.of(context).textTheme.titleMedium,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 const Icon(Iconsax.user_copy),
//                                 const SizedBox(width: CSizes.spaceBtwItems / 2),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Customer',
//                                         style: Theme.of(context).textTheme.labelMedium,
//                                       ),
//                                       Text(
//                                         order.userName,
//                                         style: Theme.of(context).textTheme.titleMedium,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   ),
// );
//
// } }