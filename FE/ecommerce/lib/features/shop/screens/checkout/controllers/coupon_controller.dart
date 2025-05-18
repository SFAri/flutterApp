import 'package:ecommerce/utils/http/http_client.dart';

class CouponController {
  Future<List<Map<String, dynamic>>> fetchCouponCode() async {
    final response = await CHttpHelper.get('coupons');
    if (response.containsKey('data')) {
      final rawList = response['data'];

      return (rawList as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('No address data found');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCouponCodeActive() async {
    final Map<String, dynamic> filter = {"isActive": true};
    final response = await CHttpHelper.post('coupons/filter', {
      'filter': filter,
    });
    if (response.containsKey('data')) {
      final rawList = response['data'];

      return (rawList as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('No address data found');
    }
  }
}
