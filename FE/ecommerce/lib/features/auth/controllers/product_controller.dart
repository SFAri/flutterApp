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
    String? searchText
  }) async {
    final body = <String, dynamic>{};

    if (filter != null) body['filter'] = filter;
    if (sortBy != null) body['sortBy'] = sortBy;
    if (searchText != null && searchText.isNotEmpty) body['searchText'] = searchText;

    print("=========body filter: $body" );

    final response = await CHttpHelper.post('products/filter', body, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> getProductDetail(String id) async {
    final response = await CHttpHelper.get('products/$id');
    return response;
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    final response = await CHttpHelper.post('products', productData, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> productData) async {
    final response = await CHttpHelper.put('products/$id', productData, withAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    final response = await CHttpHelper.delete('products/$id', withAuth: true);
    return response;
  }
}