import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ProfileRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ProfileModel?> getProfileInfo() async {
    ProfileModel? profileModel;
    Response response = await apiClient.getData(AppConstants.profileUri);
    if (response.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response.body);
    }
    return profileModel;
  }

  @override
  Future<bool> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!,
      'phone': userInfoModel.phone!, 'token': _getUserToken()
    });
    Response response = await apiClient.postMultipartData(AppConstants.updateProfileUri, fields, [MultipartBody('image', data)]);
    return (response.statusCode == 200);
  }

  @override
  Future<ResponseModel> deleteVendor() async {
    ResponseModel responseModel;
    Response response = await apiClient.deleteData(AppConstants.vendorRemoveUri, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, 'your_account_remove_successfully'.tr);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  void updateHeader(int? moduleID) {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), sharedPreferences.getString(AppConstants.languageCode), moduleID,
      sharedPreferences.getString(AppConstants.type),
    );
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