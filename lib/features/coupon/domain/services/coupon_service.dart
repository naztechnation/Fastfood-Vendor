import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/coupon/domain/models/coupon_body_model.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service_interface.dart';

class CouponService implements CouponServiceInterface {
  final CouponRepositoryInterface couponRepositoryInterface;
  CouponService({required this.couponRepositoryInterface});

  @override
  Future<ResponseModel> addCoupon(Map<String, String?> data) async {
    return await couponRepositoryInterface.addCoupon(data);
  }

  @override
  Future<ResponseModel> updateCoupon(Map<String, String?> body) async {
    return await couponRepositoryInterface.update(body);
  }

  @override
  Future<List<CouponBodyModel>?> getCouponList(int offset) async {
    return await couponRepositoryInterface.getCouponList(offset);
  }

  @override
  Future<CouponBodyModel?> getCouponDetails(int id) async {
    return await couponRepositoryInterface.get(id);
  }

  @override
  Future<bool> changeStatus(int? couponId, int status) async {
    return await couponRepositoryInterface.changeStatus(couponId, status);
  }

  @override
  Future<ResponseModel> deleteCoupon(int? couponId) async {
    return await couponRepositoryInterface.delete(couponId);
  }

}