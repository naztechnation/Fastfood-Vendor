import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_permission_body_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service_interface.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface});

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  ModulePermissionBodyModel? _modulePermissionBody;
  ModulePermissionBodyModel? get modulePermission => _modulePermissionBody;

  Future<void> getProfile() async {
    ProfileModel? profileModel = await profileServiceInterface.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
      Get.find<SplashController>().setModule(_profileModel!.stores![0].module!.id, _profileModel!.stores![0].module!.moduleType);
      profileServiceInterface.updateHeader(_profileModel!.stores![0].module!.id);
      _allowModulePermission(_profileModel!.roles);
    }
    update();
  }

  Future<bool> updateUserInfo(ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    bool isSuccess = await profileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (isSuccess) {
      await getProfile();
      Get.back();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(picked != null) {
      _pickedFile = picked;
    }
    update();
  }

  Future deleteVendor() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.deleteVendor();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  void _allowModulePermission(List<String>? roles) {
    debugPrint('---permission--->>$roles');
    if(roles != null && roles.isNotEmpty){
      List<String> module = roles;
      if (kDebugMode) {
        print(module);
      }
      _modulePermissionBody = ModulePermissionBodyModel(
        item: module.contains('item'),
        order: module.contains('order'),
        storeSetup: module.contains('store_setup'),
        addon: module.contains('addon'),
        wallet: module.contains('wallet'),
        bankInfo: module.contains('bank_info'),
        employee: module.contains('employee'),
        myShop: module.contains('my_shop'),
        customRole: module.contains('custom_role'),
        campaign: module.contains('campaign'),
        reviews: module.contains('reviews'),
        pos: module.contains('pos'),
        chat: module.contains('chat'),
      );
    }else{
      _modulePermissionBody = ModulePermissionBodyModel(item: true, order: true, storeSetup: true, addon: true, wallet: true,
        bankInfo: true, employee: true, myShop: true, customRole: true, campaign: true, reviews: true, pos: true, chat: true,
      );
    }
  }

  void initData() {
    _pickedFile = null;
  }

}