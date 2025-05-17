import 'package:ecommerce/utils/http/http_client.dart';

class OrderController {
  Future<Map<String, dynamic>> fetchOrders() async {
    try {
      final response = await CHttpHelper.get('orders', withAuth: true);
      return response as Map<String, dynamic>;
    } catch (e) {
      print('Lỗi khi lấy đơn hàng: $e');
    }
    return {};
  }
}


