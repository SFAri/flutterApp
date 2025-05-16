import 'package:ecommerce/utils/http/http_client.dart';

class LoginController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await CHttpHelper.post('auth/login', {
      'email': email,
      'password': password,
    });
    return response.containsKey('data') ? response['data'] : response;
  }

  Future<Map<String, dynamic>> register(String fullName, String email, String password, String confirm, String province, String district, String ward, String detailAddress) async {
    final response = await CHttpHelper.post('auth/register', {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirm,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress
    });
    return response.containsKey('data') ? response['data'] : response;
  }
}
