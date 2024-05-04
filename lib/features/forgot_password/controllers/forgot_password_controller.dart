import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/services/forgot_password_service_interface.dart';

class ForgotPasswordController extends GetxController implements GetxService {
  final ForgotPasswordServiceInterface forgotPasswordServiceInterface;
  ForgotPasswordController({required this.forgotPasswordServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  Future<bool> changePassword(ProfileModel updatedUserModel, String password) async {
    _isLoading = true;
    update();
    bool isSuccess = await forgotPasswordServiceInterface.changePassword(updatedUserModel, password);
    _isLoading = false;
    if (isSuccess) {
      Get.back();
      showCustomSnackBar('password_updated_successfully'.tr, isError: false);
    }
    update();
    return isSuccess;
  }

  Future<ResponseModel> forgetPassword(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.forgetPassword(email);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.verifyToken(email, _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String? email, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.resetPassword(resetToken, email, password, confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

}