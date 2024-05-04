import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface {
  Future<dynamic> joinCampaign(int? campaignID);
  Future<dynamic> leaveCampaign(int? campaignID);
}