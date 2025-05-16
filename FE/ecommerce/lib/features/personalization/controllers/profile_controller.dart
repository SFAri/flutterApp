import 'package:ecommerce/utils/http/http_client.dart';
import 'package:intl/intl.dart';

class ProfileController {
  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await CHttpHelper.get('users/profile', withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }

  Future<Map<String, dynamic>> updateProfile(
    String fullName,
    String userName,
    String phone,
    String gender,
    String dateOfBirth,
    String? profileImage,
  ) async {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");

    DateTime parsedDate = inputFormat.parse(dateOfBirth);
    dateOfBirth = outputFormat.format(parsedDate);
    print(dateOfBirth);
    final response = await CHttpHelper.put('users/profile', {
      'fullName': fullName,
      'userName': userName,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      // 'profileImage': profileImage,
    }, withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }
}
