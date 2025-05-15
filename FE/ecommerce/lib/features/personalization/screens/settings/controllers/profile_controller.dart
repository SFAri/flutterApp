import 'package:ecommerce/utils/http/http_client.dart';

class ProfileController {
  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await CHttpHelper.get('users/profile', withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }
}
