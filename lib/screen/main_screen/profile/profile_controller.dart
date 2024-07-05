import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class ProfileController extends GetxController {
  final User user = FirebaseAuth.instance.currentUser!;
  RxBool isAllowChangePass = false.obs;
  RxString photoUrl = ''.obs;
  RxString name = ''.obs;

  @override
  void onInit() {
    photoUrl.value =
        Get.context!.read<DataAppProvider>().userInfoModel!.photoUrl;
    name.value =
        Get.context!.read<DataAppProvider>().userInfoModel!.displayName;
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
