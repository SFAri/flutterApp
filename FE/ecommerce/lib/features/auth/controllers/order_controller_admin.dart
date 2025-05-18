import 'package:ecommerce/utils/http/http_client.dart';
class OrderAdminController {
  Future<Map<String, dynamic>> getOrders() async {
    final response = await CHttpHelper.get('orders', withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> filterOrders({
    Map<String, dynamic>? filter,
    Map<String, dynamic>? sortBy,
  }) async {
    final body = <String, dynamic>{};

    if (filter != null) body['filter'] = filter;
    if (sortBy != null) body['sortBy'] = sortBy;

    print("=========body filter: $body" );

    final response = await CHttpHelper.post('orders/filter', body);
    return response;
  }

  Future<Map<String, dynamic>> getOrderDetail(String id) async {
    final response = await CHttpHelper.get('orders/$id');
    return response;
  }

  Future<Map<String, dynamic>> updateOrdertatus(String id, Map<String, dynamic> orderData) async {
    final response = await CHttpHelper.put('orders/$id', orderData, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> deleteCoupon(String id) async {
    final response = await CHttpHelper.delete('orders/$id', withAuth: true);
    return response;
  }
}