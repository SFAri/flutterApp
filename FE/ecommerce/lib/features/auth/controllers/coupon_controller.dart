import 'package:ecommerce/utils/http/http_client.dart';
class CouponController {
  Future<Map<String, dynamic>> getCoupons() async {
    final response = await CHttpHelper.get('coupons');
    return response;
  }

  // Future<Map<String, dynamic>> filterCoupons({
  //   Map<String, dynamic>? filter,
  //   Map<String, dynamic>? sortBy,
  // }) async {
  //   final body = <String, dynamic>{};

  //   if (filter != null) body['filter'] = filter;
  //   if (sortBy != null) body['sortBy'] = sortBy;

  //   print("=========body filter: $body" );

  //   final response = await CHttpHelper.post('coupons/filter', body);
  //   return response;
  // }

  // Future<Map<String, dynamic>> getCouponDetail(String id) async {
  //   final response = await CHttpHelper.get('coupons/$id');
  //   return response;
  // }

  Future<Map<String, dynamic>> createCoupon(Map<String, dynamic> couponData) async {
    final response = await CHttpHelper.post('coupons', couponData, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> updateCoupon(String id, Map<String, dynamic> couponData) async {
    final response = await CHttpHelper.put('coupons/$id', couponData, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> deleteCoupon(String code) async {
    final response = await CHttpHelper.delete('coupons/$code', withAuth: true);
    return response;
  }
}