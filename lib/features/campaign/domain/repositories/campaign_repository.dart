import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/campaign/domain/models/campaign_model.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class CampaignRepository implements CampaignRepositoryInterface {
  final ApiClient apiClient;
  CampaignRepository({required this.apiClient});

  @override
  Future<List<CampaignModel>?> getList() async {
    List<CampaignModel>? campaignList;
    Response response = await apiClient.getData(AppConstants.basicCampaignUri);
    if (response.statusCode == 200) {
      campaignList = [];
      response.body.forEach((campaign) {
        campaignList!.add(CampaignModel.fromJson(campaign));
      });
    }
    return campaignList;
  }

  @override
  Future<bool> joinCampaign(int? campaignID) async {
    Response response = await apiClient.putData(AppConstants.joinCampaignUri, {'campaign_id': campaignID});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> leaveCampaign(int? campaignID) async {
    Response response = await apiClient.putData(AppConstants.leaveCampaignUri, {'campaign_id': campaignID});
    return (response.statusCode == 200);
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
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}