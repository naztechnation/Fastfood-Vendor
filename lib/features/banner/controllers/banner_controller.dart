import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service_interface.dart';

class BannerController extends GetxController implements GetxService {
  final BannerServiceInterface bannerServiceInterface;
  BannerController({required this.bannerServiceInterface});

  List<StoreBannerListModel>? _storeBannerList;
  List<StoreBannerListModel>? get storeBannerList => _storeBannerList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> addBanner(String title, String url, XFile image) async {
    _isLoading = true;
    update();
    bool isSuccess = await bannerServiceInterface.addBanner(title, url, image);
    if(isSuccess) {
      getBannerList();
      Get.back();
      showCustomSnackBar('banner_added_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> getBannerList() async {
    _isLoading = true;
    update();
    List<StoreBannerListModel>? storeBannerList = await bannerServiceInterface.getBannerList();
    if(storeBannerList != null) {
      _storeBannerList = [];
      _storeBannerList!.addAll(storeBannerList);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteBanner(int? bannerID) async {
    _isLoading = true;
    update();
    bool isSuccess = await bannerServiceInterface.deleteBanner(bannerID);
    if(isSuccess) {
      await getBannerList();
      Get.back();
      showCustomSnackBar('banner_deleted_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateBanner(int? bannerID, String title, String url, XFile? image) async {
    _isLoading = true;
    update();
    bool isSuccess = await bannerServiceInterface.updateBanner(bannerID, title, url, image);
    if(isSuccess) {
      await getBannerList();
      Get.back();
      showCustomSnackBar('banner_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

}