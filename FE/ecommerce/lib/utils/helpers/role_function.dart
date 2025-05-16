import 'dart:convert';

int getRoleFromToken(String token) {
  // Tách token thành các phần
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT token');
  }

  // Giải mã phần payload
  final payload = parts[1];
  final decodedPayload = utf8.decode(base64Url.decode(base64Url.normalize(payload)));

  // Chuyển đổi JSON thành Map
  final Map<String, dynamic> payloadMap = json.decode(decodedPayload);
  print("PayloadMap: " +  payloadMap.toString());

  // Lấy vai trò từ payload (giả sử vai trò được lưu dưới key 'role')
  return payloadMap['payload']['role'] ?? 0; // Hoặc giá trị mặc định
}