import 'dart:async';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/repositories/forgot_password_repository_interface.dart';

class ForgotPasswordRepository implements ForgotPasswordRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ForgotPasswordRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<bool> changePassword(ProfileModel userInfoModel, String password) async {
    Response response = await apiClient.postData(AppConstants.updateProfileUri, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'phone': userInfoModel.phone, 'password': password, 'token': _getUserToken()});
    return (response.statusCode == 200);
  }

  @override
  Future<ResponseModel> forgetPassword(String? email) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.forgetPasswordUri, {"email": email}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> verifyToken(String? email, String token) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.verifyTokenUri, {"email": email, "reset_token": token}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String? email, String password, String confirmPassword) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.resetPasswordUri,
      {"_method": "put", "email": email, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}