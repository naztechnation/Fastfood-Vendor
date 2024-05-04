import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service_interface.dart';

class BannerService implements BannerServiceInterface {
  final BannerRepositoryInterface bannerRepositoryInterface;
  BannerService({required this.bannerRepositoryInterface});

  @override
  Future<bool> addBanner(String title, String url, XFile image) async {
    return await bannerRepositoryInterface.addBanner(title, url, image);
  }

  @override
  Future<List<StoreBannerListModel>?> getBannerList() async {
    return await bannerRepositoryInterface.getList();
  }

  @override
  Future<bool> deleteBanner(int? bannerID) async {
    return await bannerRepositoryInterface.delete(bannerID);
  }

  @override
  Future<bool> updateBanner(int? bannerID, String title, String url, XFile? image) async {
    return await bannerRepositoryInterface.updateBanner(bannerID, title, url, image);
  }

}