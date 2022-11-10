import 'package:localstorage/localstorage.dart';

class StorageManager {
  final String _keyValue = 'storage';
  static final LocalStorage favouritesStorage = LocalStorage('favouritesStorage');

  saveToStorage(LocalStorage storage, List<dynamic> map) {
    storage.setItem(_keyValue, map);
  }

  List<dynamic>  readFromStorage(LocalStorage storage) {
    List<dynamic> result = storage.getItem(_keyValue) ?? [];
    return result;
  }

  clearStorage(LocalStorage storage) async {
    await storage.clear();
  }
}
