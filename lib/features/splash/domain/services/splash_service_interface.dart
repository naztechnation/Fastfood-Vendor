import 'package:get/get.dart';

abstract class SplashServiceInterface {
  Future<Response> getConfigData();
  Future<bool> initSharedData();
  bool showIntro();
  void setIntro(bool intro);
  Future<bool> removeSharedData();
}