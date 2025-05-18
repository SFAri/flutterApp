import 'package:ecommerce/utils/http/http_client.dart';
import '../../admin/models/Order.dart';

class OrderController {
  Future<List<Order>> getOrders() async {
    try {
      final response = await CHttpHelper.get('orders', withAuth: true);
      print(response);
      final data = response as Map<String, dynamic>;
      final List<dynamic> ordersJson = data['data'] ?? [];
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Lỗi khi lấy đơn hàng: $e');
      return [];
    }
  }

  /// Hàm cập nhật trạng thái đơn hàng
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final path = 'orders/status/$orderId';
      final body = {
        'status': newStatus,
      };

      final Map<String, dynamic> response =
      await CHttpHelper.put(path, body, withAuth: true);

      // Ví dụ kiểm tra trường 'success' hoặc 'code' trong response
      if (response.containsKey('success')) {
        return response['success'] == true;
      }
      if (response.containsKey('code')) {
        return response['code'] == 200 || response['code'] == 201;
      }
      // Nếu API trả về dữ liệu khác, bạn cần điều chỉnh lại cho phù hợp
      // Tạm coi trả về true nếu không lỗi
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái đơn hàng: $e');
      return false;
    }
  }
}
