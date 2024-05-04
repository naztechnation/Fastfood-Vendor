import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/coupon/domain/models/coupon_body_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service_interface.dart';

class CouponController extends GetxController implements GetxService {
  final CouponServiceInterface couponServiceInterface;
  CouponController({required this.couponServiceInterface});

  int _couponTypeIndex = 0;
  int get couponTypeIndex => _couponTypeIndex;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CouponBodyModel>? _coupons;
  List<CouponBodyModel>? get coupons => _coupons;

  CouponBodyModel? _couponDetails;
  CouponBodyModel? get couponDetails => _couponDetails;

  void setCouponTypeIndex(int index, bool notify) {
    _couponTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getCouponList() async {
    List<CouponBodyModel>? coupons = await couponServiceInterface.getCouponList(1);
    if(coupons != null) {
      _coupons = [];
      _coupons!.addAll(coupons);
    }
    update();
  }

  Future<CouponBodyModel?> getCouponDetails(int id) async {
    _couponDetails = null;
    CouponBodyModel? couponDetails = await couponServiceInterface.getCouponDetails(id);
    if(couponDetails != null) {
      _couponDetails = couponDetails;
    }
    update();
    return _couponDetails;
  }

  Future<bool> changeStatus(int? couponId, bool status) async {
    bool success = await couponServiceInterface.changeStatus(couponId, status ? 1 : 0);
    return success;
  }

  Future<bool> deleteCoupon(int? couponId) async {
    _isLoading = true;
    update();
    bool success = false;
    ResponseModel responseModel = await couponServiceInterface.deleteCoupon(couponId);
    if(responseModel.isSuccess) {
      success = true;
      getCouponList();
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return success;
  }

  Future<void> addCoupon({String? code, String? title, String? startDate, String? expireDate, String? discount, String? couponType, String? discountType,
    String? limit, String? maxDiscount, String? minPurches,}) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    ResponseModel responseModel = await couponServiceInterface.addCoupon(data);
    if(responseModel.isSuccess) {
      getCouponList();
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateCoupon({String? couponId, String? code, String? title, String? startDate, String? expireDate, String? discount, String? couponType,
    String? discountType, String? limit, String? maxDiscount, String? minPurches}) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "coupon_id": couponId,
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    ResponseModel responseModel = await couponServiceInterface.updateCoupon(data);
    if(responseModel.isSuccess) {
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
      getCouponList();
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
  }

}