import 'package:ecommerce/utils/http/http_client.dart';
class ProductController {
  Future<Map<String, dynamic>> getProducts() async {
    final response = await CHttpHelper.get('products');
    // return response.containsKey('data') ? response['data'] : response;
    return response;
  }

  Future<Map<String, dynamic>> filterProducts({
    Map<String, dynamic>? filter,
    Map<String, dynamic>? sortBy,
  }) async {
    final body = <String, dynamic>{};

    if (filter != null) body['filter'] = filter;
    if (sortBy != null) body['sortBy'] = sortBy;

    print("=========body filter: $body" );

    final response = await CHttpHelper.post('products/filter', body);
    return response;
  }

  Future<Map<String, dynamic>> getProductDetail(String id) async {
    final response = await CHttpHelper.get('products/$id');
    // return response.containsKey('data') ? response['data'] : response;
    return response;
  }
}