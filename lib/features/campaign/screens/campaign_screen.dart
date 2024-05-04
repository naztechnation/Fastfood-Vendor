import 'package:sixam_mart_store/features/campaign/controllers/campaign_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/features/campaign/widgets/campaign_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getCampaignList();

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'campaign'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem('all', context),
            const PopupMenuDivider(),
            getMenuItem('joined', context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        offset: const Offset(-25, 25),
        child: Container(
          width: 40, height: 40,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: const Icon(Icons.arrow_drop_down, size: 30),
        ),
        onSelected: (dynamic value) {
          Get.find<CampaignController>().filterCampaign(value);
        },
      )),

      body: GetBuilder<CampaignController>(builder: (campaignController) {
        return campaignController.campaignList != null ? campaignController.campaignList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<CampaignController>().getCampaignList();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: campaignController.campaignList!.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CampaignWidget(campaignModel: campaignController.campaignList![index]);
            },
          ),
        ) : Center(child: Text('no_campaign_available'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.tr, style: robotoRegular.copyWith(color: status == 'joined' ? Colors.green : null)),
    );
  }
}
