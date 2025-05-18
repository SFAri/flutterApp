// order_management.dart
import 'package:ecommerce/features/admin/screens/orderManagement/orderDetail/order_details.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../auth/controllers/order_controller.dart';
import '../../models/Order.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final orderController = OrderController();
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  bool _isLoading = true;

  // Pagination
  int currentPage = 0;
  final int rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final fetchedOrders = await orderController.getOrders();
      setState(() {
        _orders = fetchedOrders;
        _filteredOrders = fetchedOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Lỗi khi fetch orders: $e');
    }
  }

  void _filterOrders(String query) {
    setState(() {
      currentPage = 0; // reset về trang đầu
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
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, _filteredOrders.length);
    final visibleOrders = _filteredOrders.sublist(start, end);

    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF303030), // Khung đen tím
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Items')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: visibleOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order.id)),
                      DataCell(Text(_formatDate(order.createdAt))),
                      DataCell(Text('${order.items.length} sản phẩm')),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(color: _getStatusColor(order.status)),
                        ),
                      )),
                      DataCell(Text('${order.totalAmount.toStringAsFixed(0)} ₫')),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.white70),
                            onPressed: () {
                              streamController.add(OrderDetailScreen(order: order));
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${start + 1}–$end of ${_filteredOrders.length}',
                  style: const TextStyle(color: Colors.white70),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white70),
                  onPressed: currentPage > 0
                      ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white70),
                  onPressed: end < _filteredOrders.length
                      ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

