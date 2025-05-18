// order_details.dart
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';
import '../order_management.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
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

  void _confirmUpdateStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Are you sure you have the adjustment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order status updated successfully.')),
              );
              // Logic to sync with backend or customer view should be added here
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header(title: 'Order Details:'),
            // Divider(),
            
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: ${widget.order.id}', style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Date: ${widget.order.date}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('Items: ${widget.order.items}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('Amount: \$${widget.order.amount.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _selectedStatus,
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    items: ['Pending', 'Cancelled', 'Delivered', 'Shipped']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status, style: TextStyle(color: _getStatusColor(status))),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _confirmUpdateStatus,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    child: const Text('Cập nhật trạng thái'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
