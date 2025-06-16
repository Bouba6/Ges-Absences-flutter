import 'package:get/get.dart';

class UserDataService extends GetxService {
  final RxnString vigileId = RxnString();

  void setVigileId(String id) {
    vigileId.value = id;
  }

  String? get getVigileId => vigileId.value;
}
