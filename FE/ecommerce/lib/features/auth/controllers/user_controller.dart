import 'package:ecommerce/utils/http/http_client.dart';
class UserAdminController {
  Future<Map<String, dynamic>> getUsers() async {
    final response = await CHttpHelper.get('users');
    return response;
  }
  
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData) async {
    final response = await CHttpHelper.put('users/$id', userData, withAuth: true);
    return response;
  }
}