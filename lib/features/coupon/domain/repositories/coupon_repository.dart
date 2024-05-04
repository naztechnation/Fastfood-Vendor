import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/coupon/domain/models/coupon_body_model.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class CouponRepository implements CouponRepositoryInterface {
  final ApiClient apiClient;
  CouponRepository({required this.apiClient});

  @override
  Future<ResponseModel> addCoupon(Map<String, String?> data) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.addCouponUri, data, handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> update(Map<String, dynamic> body) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.couponUpdateUri, body, handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<List<CouponBodyModel>?> getCouponList(int offset) async {
    List<CouponBodyModel>? coupons;
    Response response = await apiClient.getData('${AppConstants.couponListUri}?limit=50&offset=$offset');
    if(response.statusCode == 200) {
      coupons = [];
      response.body.forEach((coupon){
        coupons!.add(CouponBodyModel.fromJson(coupon));
      });
    }
    return coupons;
  }

  @override
  Future<CouponBodyModel?> get(int? id) async {
    CouponBodyModel? couponDetails;
    Response response = await apiClient.getData('${AppConstants.couponDetailsUri}?coupon_id=$id');
    if(response.statusCode == 200) {
      couponDetails = CouponBodyModel.fromJson(response.body[0]);
    }
    return couponDetails;
  }

  @override
  Future<bool> changeStatus(int? couponId, int status) async {
    bool success = false;
    Response response = await apiClient.postData(AppConstants.couponChangeStatusUri,{"coupon_id": couponId, "status": status});
    if(response.statusCode == 200) {
      success = true;
      showCustomSnackBar(response.body['message'], isError: false);
    }
    return success;
  }

  @override
  Future<ResponseModel> delete(int? id) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.couponDeleteUri,{"coupon_id": id}, handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

}