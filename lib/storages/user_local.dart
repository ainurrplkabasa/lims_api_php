import 'package:get_storage/get_storage.dart';

class UserLocal {
  final box = GetStorage();
  final _key = "UserKeyyy";

  Future<void> saveUser(Map<String, dynamic> data) => box.write(_key, data);

  bool get hasLogin => box.hasData(_key);

  Map<String, dynamic>? get getUser => hasLogin ? box.read(_key) : null;

  Future<void> logout() => box.remove(_key);
}
