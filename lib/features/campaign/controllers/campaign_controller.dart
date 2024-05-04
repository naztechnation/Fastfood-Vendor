import 'package:sixam_mart_store/features/campaign/domain/models/campaign_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service_interface.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignServiceInterface campaignServiceInterface;
  CampaignController({required this.campaignServiceInterface});

  List<CampaignModel>? _campaignList;
  List<CampaignModel>? get campaignList => _campaignList;

  late List<CampaignModel> _allCampaignList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getCampaignList() async {
    List<CampaignModel>? campaignList = await campaignServiceInterface.getCampaignList();
    if(campaignList != null) {
      _campaignList = [];
      _allCampaignList = [];
      _campaignList!.addAll(campaignList);
      _allCampaignList.addAll(campaignList);
    }
    update();
  }

  void filterCampaign(String status) {
    _campaignList = campaignServiceInterface.filterCampaign(status, _allCampaignList);
    update();
  }

  Future<void> joinCampaign(int? campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    bool isSuccess = await campaignServiceInterface.joinCampaign(campaignID);
    Get.back();
    if(isSuccess) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_joined'.tr, isError: false);
      getCampaignList();
    }
    _isLoading = false;
    update();
  }

  Future<void> leaveCampaign(int? campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    bool isSuccess = await campaignServiceInterface.leaveCampaign(campaignID);
    Get.back();
    if(isSuccess) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_leave'.tr, isError: false);
      getCampaignList();
    }
    _isLoading = false;
    update();
  }

}