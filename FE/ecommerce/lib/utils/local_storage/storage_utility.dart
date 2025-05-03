import 'package:get_storage/get_storage.dart';

class CLocalStorage {
  late final GetStorage _storage;

  // Singleton instance
  static CLocalStorage? _instance;

  CLocalStorage._internal();

  factory CLocalStorage.instance() {
    _instance ??= CLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = CLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  // Generic method to save data
  Future<void> writeData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generic method to read data
  Future<T?> readData<T>(String key) async {
    return await _storage.read<T>(key);
  }

  // Generic method to remove data
  Future<void> deleteData(String key) async {
    await _storage.remove(key);
  }
}
