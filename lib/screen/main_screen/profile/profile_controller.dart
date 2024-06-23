import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ProfileController extends GetxController {
  final User user = FirebaseAuth.instance.currentUser!;
  RxBool isAllowChangePass = false.obs;
  Rx<String?> photoUrl = Rx<String?>(null);
  Rx<String?> name = Rx<String?>(null);

  @override
  void onInit() {
    photoUrl.value = user.photoURL;
    name.value = user.displayName;
    isAllowChangePass.value = checkIsMethodSigin();
    super.onInit();
  }

  bool checkIsMethodSigin() {
    List<UserInfo> providers = user.providerData;
    for (UserInfo userInfo in providers) {
      switch (userInfo.providerId) {
        case 'google.com':
          return false;
        case 'password':
          return true;
      }
    }
    return false;
  }
}
