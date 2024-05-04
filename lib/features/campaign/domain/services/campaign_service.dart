import 'package:sixam_mart_store/features/campaign/domain/models/campaign_model.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service_interface.dart';

class CampaignService implements CampaignServiceInterface {
  final CampaignRepositoryInterface campaignRepositoryInterface;
  CampaignService({required this.campaignRepositoryInterface});

  @override
  Future<List<CampaignModel>?> getCampaignList() async {
    return await campaignRepositoryInterface.getList();
  }

  @override
  Future<bool> joinCampaign(int? campaignID) async {
    return await campaignRepositoryInterface.joinCampaign(campaignID);
  }

  @override
  Future<bool> leaveCampaign(int? campaignID) async {
    return await campaignRepositoryInterface.leaveCampaign(campaignID);
  }

  @override
  List<CampaignModel>? filterCampaign(String status, List<CampaignModel> allCampaignList) {
    List<CampaignModel>? campaignList = [];
    if(status == 'joined') {
      for (var campaign in allCampaignList) {
        if(campaign.isJoined!) {
          campaignList.add(campaign);
        }
      }
    }else {
      campaignList.addAll(allCampaignList);
    }
    return campaignList;
  }

}