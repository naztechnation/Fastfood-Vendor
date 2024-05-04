import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/store_body_model.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}){
    _notification = authServiceInterface.isNotificationActive();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _notification = true;
  bool get notification => _notification;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  final List<String?> _deliveryTimeTypeList = ['minute', 'hours', 'days'];
  List<String?> get deliveryTimeTypeList => _deliveryTimeTypeList;

  int _deliveryTimeTypeIndex = 0;
  int get deliveryTimeTypeIndex => _deliveryTimeTypeIndex;

  int _vendorTypeIndex = 0;
  int get vendorTypeIndex => _vendorTypeIndex;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  double _storeStatus = 0.4;
  double get storeStatus => _storeStatus;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  Future<ResponseModel> login(String? email, String password, String type) async {
    _isLoading = true;
    update();
    Response response = await authServiceInterface.login(email, password, type);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authServiceInterface.saveUserToken(response.body['token'], response.body['zone_wise_topic'], type);
      if(response.body['role'] != null && type == 'employee'){
      }
      await authServiceInterface.updateToken();
      Get.find<ProfileController>().getProfile();
      responseModel = ResponseModel(true, 'successful');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForReg(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }


  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void changeVendorType(int index, {bool isUpdate = true}){
    _vendorTypeIndex = index;
    if(isUpdate) {
      update();
    }
  }

  Future<bool> clearSharedData() async {
    Get.find<SplashController>().setModule(null, null);
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String type) {
    authServiceInterface.saveUserNumberAndPassword(number, password, type);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }
  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }
  String getUserType() {
    return authServiceInterface.getUserType();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }


  Future<void> toggleStoreClosedStatus() async {
    bool isSuccess = await authServiceInterface.toggleStoreClosedStatus();
    if (isSuccess) {
      Get.find<ProfileController>().getProfile();
    }
    update();
  }

  Future<void> registerStore(StoreBodyModel storeBody) async {
    _isLoading = true;
    update();
    bool isSuccess = await authServiceInterface.registerRestaurant(storeBody, _pickedLogo, _pickedCover);
    if(isSuccess) {
      Get.offAllNamed(RouteHelper.getSignInRoute());
      showCustomSnackBar(Get.find<SplashController>().moduleType == 'food' ? 'restaurant_registration_successful'.tr : 'store_registration_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void setDeliveryTimeTypeIndex(String? type, bool notify) {
    _deliveryTimeTypeIndex = _deliveryTimeTypeList.indexOf(type);
    if(notify) {
      update();
    }
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}){
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

}