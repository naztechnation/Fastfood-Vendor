import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class ForgotPasswordRepositoryInterface implements RepositoryInterface {
  Future<dynamic> changePassword(ProfileModel userInfoModel, String password);
  Future<dynamic> forgetPassword(String? email);
  Future<dynamic> verifyToken(String? email, String token);
  Future<dynamic> resetPassword(String? resetToken, String? email, String password, String confirmPassword);
}