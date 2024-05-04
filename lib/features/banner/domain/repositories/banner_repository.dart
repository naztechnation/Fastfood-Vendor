import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository_interface.dart';

class BannerRepository implements BannerRepositoryInterface {
  final ApiClient apiClient;
  BannerRepository({required this.apiClient});

  @override
  Future<bool> addBanner(String title, String url, XFile image) async {
    Response response = await apiClient.postMultipartData(AppConstants.addStoreBannerUri, {'title': title, 'default_link': url}, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future<List<StoreBannerListModel>?> getList() async {
    List<StoreBannerListModel>? storeBannerList;
    Response response = await apiClient.getData(AppConstants.storeBannerUri);
    if(response.statusCode == 200) {
      storeBannerList = [];
      response.body.forEach((item) => storeBannerList!.add(StoreBannerListModel.fromJson(item)));
    }
    return storeBannerList;
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteStoreBannerUri}?id=$id');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateBanner(int? bannerID, String title, String url, XFile? image) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{'_method': 'put', 'id': bannerID.toString(), 'title': title, 'default_link': url});
    Response response = await apiClient.postMultipartData(AppConstants.updateStoreBannerUri, fields, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}