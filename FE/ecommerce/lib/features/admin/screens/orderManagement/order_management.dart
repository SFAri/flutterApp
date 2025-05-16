// order_management.dart
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/orderManagement/orderDetail/order_details.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final String date;
  final String items;
  final String status;
  final double amount;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
    required this.amount,
  });
}

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});
  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final List<Order> _orders = [
    Order(id: '1f3bd8f', date: '27 Jun 2024', items: '1 Items', status: 'Delivered', amount: 5262.4),
    Order(id: '1f4797f', date: '27 Jun 2024', items: '1 Items', status: 'Cancelled', amount: 5202.2),
    Order(id: '1f4240c', date: '02 Jul 2024', items: '1 Items', status: 'Pending', amount: 5140.0),
    Order(id: '1f208a9', date: '27 Jun 2024', items: '1 Items', status: 'Shipped', amount: 5224.2),
    Order(id: '1f2642f', date: '27 Jun 2024', items: '1 Items', status: 'Delivered', amount: 5170.0),
  ];

  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = _orders;
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _orders;
      } else {
        _filteredOrders = _orders
            .where((order) => order.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Cancelled':
        return Colors.red;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: 'Order Management'),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                width: 300,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Find order:',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  onChanged: _filterOrders,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Items')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: _filteredOrders.map((order) {
                      return DataRow(cells: [
                        DataCell(Text(order.id)),
                        DataCell(Text(order.date)),
                        DataCell(Text(order.items)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(color: _getStatusColor(order.status)),
                            ),
                          ),
                        ),
                        DataCell(Text('\$${order.amount.toStringAsFixed(1)}')),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye, color: Colors.white70),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailScreen(order: order),
                                  ),
                                );
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}