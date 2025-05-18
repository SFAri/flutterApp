// order_details.dart
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../auth/controllers/order_controller.dart';
import '../../../models/Order.dart';
import '../order_management.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _selectedStatus;

  // Danh sách trạng thái chuẩn hóa có hoa chữ đầu
  final List<String> _statuses = ['Pending', 'Cancelled', 'Delivered', 'Shipped'];

  @override
  void initState() {
    super.initState();
    // Chuẩn hóa trạng thái đầu vào để tránh lỗi DropdownButton
    _selectedStatus = _capitalize(widget.order.status);
    if (!_statuses.contains(_selectedStatus)) {
      _selectedStatus = _statuses.first;
    }
  }

  // Hàm chuyển trạng thái thành dạng chữ hoa chữ cái đầu, chữ thường phần còn lại
  String _capitalize(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
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
    final order = widget.order;
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
            onPressed: () async {
              Navigator.pop(context); // Đóng dialog trước khi cập nhật
              final success = await OrderController().updateOrderStatus(order.id, _selectedStatus);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order status updated successfully.')),
                );
                // Nếu cần cập nhật UI thì gọi setState() ở đây hoặc callback
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update order status.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('Yes'),
          ),

        ],
      ),
    );
  }

  String formatCurrency(num amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
<<<<<<< HEAD
            // Header(title: 'Order Details:'),
            // Divider(),
            
=======
            Header(title: 'Order Details:'),
            const Divider(),

>>>>>>> 67520c02a0e4e28683efe4fb31b53940b7cf73be
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: ${order.id}', style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}',
                      style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 16),

                  const Text('Products:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),

                  ...order.items.map((item) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('Variant: ${item.variantId}', style: const TextStyle(color: Colors.white70)),
                        Text('Quantity: ${item.quantity}', style: const TextStyle(color: Colors.white70)),
                        Text('Unit Price: ${formatCurrency(item.unitPrice)}', style: const TextStyle(color: Colors.white70)),
                        Text('Discount: ${formatCurrency(item.discountPerProduct)}', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )),

                  const Divider(height: 32),

                  Text('Subtotal: ${formatCurrency(order.subtotal)}', style: const TextStyle(color: Colors.white70)),
                  if (order.coupon != null)
                    Text('Coupon (${order.coupon!.code}): -${formatCurrency(order.coupon!.discountAmount)}',
                        style: const TextStyle(color: Colors.white70)),
                  Text('Tax: ${formatCurrency(order.taxAmount)}', style: const TextStyle(color: Colors.white70)),
                  Text('Shipping Fee: ${formatCurrency(order.shippingFee)}', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('Total Amount: ${formatCurrency(order.totalAmount)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.lightBlueAccent)),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: _selectedStatus,
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    items: _statuses
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
