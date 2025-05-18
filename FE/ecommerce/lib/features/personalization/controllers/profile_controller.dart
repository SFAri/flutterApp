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

  // Get user address
  Future<List<Map<String, dynamic>>> fetchUserAddress() async {
    final response = await CHttpHelper.get('users/address', withAuth: true);

    if (response.containsKey('data')) {
      final rawList = response['data'];

      return (rawList as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('No address data found');
    }
  }

  // Get user address default
  Future<Map<String, dynamic>> fetchUserAddressDefault() async {
    final response = await CHttpHelper.get(
      'users/address/isDefault',
      withAuth: true,
    );
    return response.containsKey('data') ? response['data'] : response;
  }

  // Add new address
  Future<Map<String, dynamic>> addNewAddress(
    String fullName,
    String phone,
    String province,
    String district,
    String ward,
    String detailAddress,
    bool isDefault,
  ) async {
    final response = await CHttpHelper.post('users/address', {
      'fullName': fullName,
      'phone': phone,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
    }, withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }

  // Update address
  Future<Map<String, dynamic>> updateAddress(
    String id,
    String fullName,
    String phone,
    String province,
    String district,
    String ward,
    String detailAddress,
    bool isDefault,
  ) async {
    final response = await CHttpHelper.put('users/address/$id', {
      'fullName': fullName,
      'phone': phone,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
    }, withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }

  // Update address
  Future<Map<String, dynamic>> setDefaultAddress(
    String id,
    bool isDefault,
  ) async {
    final response = await CHttpHelper.put('users/address/$id', {
      'isDefault': isDefault,
    }, withAuth: true);
    return response.containsKey('data') ? response['data'] : response;
  }

  // Delete address
  Future<void> deleteAddress(String id) async {
    await CHttpHelper.delete('users/address/$id', withAuth: true);
  }
}
