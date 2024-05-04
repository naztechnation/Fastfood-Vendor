import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class CouponRepositoryInterface implements RepositoryInterface {
  Future<dynamic> addCoupon(Map<String, String?> data);
  Future<dynamic> getCouponList(int offset);
  Future<dynamic> changeStatus(int? couponId, int status);
}