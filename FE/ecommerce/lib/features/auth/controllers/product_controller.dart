import 'package:ecommerce/utils/http/http_client.dart';
class ProductController {
  Future<Map<String, dynamic>> getProducts() async {
    final response = await CHttpHelper.get('api/products/');
    return response.containsKey('data') ? response['data'] : response;
  }
}