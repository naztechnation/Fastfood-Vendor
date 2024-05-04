import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class AddonRepository implements AddonRepositoryInterface<AddOns> {
  final ApiClient apiClient;
  AddonRepository({required this.apiClient});

  @override
  Future<bool> add(AddOns addonModel) async {
    Response response = await apiClient.postData(AppConstants.addAddonUri, addonModel.toJson());
    return (response.statusCode == 200);
  }

  @override
  Future<bool> update(Map<String, dynamic> body) async {
    Response response = await apiClient.putData(AppConstants.updateAddonUri, body);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteAddonUri}?id=$id');
    return (response.statusCode == 200);
  }

  @override
  Future<List<AddOns>?> getList() async {
    List<AddOns>? addonList;
    Response response = await apiClient.getData(AppConstants.addonUri);
    if(response.statusCode == 200) {
      addonList = [];
      response.body.forEach((addon) {
        addonList!.add(AddOns.fromJson(addon));
      });
    }
    return addonList;
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

}