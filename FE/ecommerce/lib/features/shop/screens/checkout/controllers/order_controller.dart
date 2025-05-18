import 'package:ecommerce/utils/http/http_client.dart';

class OrderController {
  Future<List<Map<String, dynamic>>> fetchOrderByUser() async {
    final response = await CHttpHelper.get('orders/user', withAuth: true);
    if (response.containsKey('data')) {
      final rawList = response['data'];

      return (rawList as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('No address data found');
    }
  }

  // Add new address
  Future<Map<String, dynamic>> createOrder(
    List<Map<String, dynamic>> cartItems,
    String couponCode,
    String paymentMethod,
    String shippingAddressId,
  ) async {
    print("cartItems: $cartItems");
    print("couponCode: $couponCode");
    print("paymentMethod: $paymentMethod");
    print("shippingAddressId: $shippingAddressId");

    final response = await CHttpHelper.post('orders', {
      'cartItems': cartItems,
      'couponCode': couponCode,
      'paymentMethod': paymentMethod,
      'shippingAddressId': shippingAddressId,
    }, withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }
}
