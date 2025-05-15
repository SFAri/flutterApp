import 'package:ecommerce/utils/http/http_client.dart';

class LoginController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await CHttpHelper.post('auth/login', {
      'email': email,
      'password': password,
    });
    return response.containsKey('data') ? response['data'] : response;
  }
}
