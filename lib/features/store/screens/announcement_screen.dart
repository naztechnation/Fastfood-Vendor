import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';

class AnnouncementScreen extends StatefulWidget {
  final int announcementStatus;
  final String announcementMessage;
  const AnnouncementScreen({super.key, required this.announcementStatus, required this.announcementMessage});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}
class _AnnouncementScreenState extends State<AnnouncementScreen> {

  final tooltipController = JustTheController();
  final TextEditingController _announcementController = TextEditingController();
  bool announcementStatus = false;

  @override
  void initState() {
    announcementStatus = widget.announcementStatus == 1 ? true : false;
    _announcementController.text = widget.announcementMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
        return Scaffold(
          appBar: CustomAppBarWidget(
            title: 'announcement'.tr,
            menuWidget: Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                trackColor: Theme.of(context).primaryColor.withOpacity(0.5),
                activeColor: Theme.of(context).primaryColor,
                value: announcementStatus,
                onChanged: (value) {
                  setState(() {
                    announcementStatus = value;
                  });
                },
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [

              Row(children: [
                Text("announcement_content".tr, style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                JustTheTooltip(
                  backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                  controller: tooltipController,
                  preferredDirection: AxisDirection.down,
                  tailLength: 14,
                  tailBaseWidth: 20,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('this_feature_is_for_sharing_important_information_or_announcements_related_to_the_store'.tr,style: robotoRegular.copyWith(color: Theme.of(context).cardColor)),
                  ),
                  child: InkWell(
                    onTap: () => tooltipController.showTooltip(),
                    child: const Icon(Icons.info_outline, size: 15),
                  ),
                  // child: const Icon(Icons.info_outline),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomTextFieldWidget(
                hintText: "type_announcement".tr,
                controller: _announcementController,
                maxLines: 5,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              !storeController.isLoading ? CustomButtonWidget(
                onPressed: () {
                  if(_announcementController.text.isEmpty) {
                    showCustomSnackBar('enter_announcement'.tr);
                  }else {
                    storeController.updateAnnouncement(announcementStatus ? 1 : 0, _announcementController.text);
                  }
                },
                buttonText: 'publish'.tr,
              ) : const Center(child: CircularProgressIndicator()),

            ]),
          ),
        );
      }
    );
  }
}
