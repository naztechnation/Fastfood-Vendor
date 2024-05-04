import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BannerListScreen extends StatefulWidget {
  const BannerListScreen({super.key});

  @override
  State<BannerListScreen> createState() => _BannerListScreenState();
}

class _BannerListScreenState extends State<BannerListScreen> {
  final tooltipController = JustTheController();
  @override
  void initState() {
    Get.find<BannerController>().getBannerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'banner_list'.tr,
        menuWidget: Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
          child: JustTheTooltip(
            backgroundColor: Colors.black87,
            controller: tooltipController,
            preferredDirection: AxisDirection.down,
            tailLength: 14,
            tailBaseWidth: 20,
            content: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Image.asset(Images.noteIcon, height: 21, width: 21),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('note'.tr, style: robotoBold.copyWith(color: Colors.white)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text('customer_will_see_these_banners_in_your_store_details_page_in_website_and_user_apps'.tr,
                  style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
            ),
            child: InkWell(
              onTap: () => tooltipController.showTooltip(),
              child: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            ),
            // child: const Icon(Icons.info_outline),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: GetBuilder<BannerController>(builder: (bannerController) {

                  return bannerController.storeBannerList != null ? bannerController.storeBannerList!.isNotEmpty ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: bannerController.storeBannerList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 180, width: Get.width,
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 0))],
                        ),
                        child: Column(children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                              child: CustomImageWidget(
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl}/${bannerController.storeBannerList![index].image}',
                                fit: BoxFit.cover, width: Get.width,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                Wrap(crossAxisAlignment: WrapCrossAlignment.center, runAlignment: WrapAlignment.center, children: [
                                  Text('${'redirection_url'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: bannerController.storeBannerList![index].defaultLink != null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor)),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  InkWell(
                                    onTap: () {
                                      if(bannerController.storeBannerList![index].defaultLink != null) {
                                        _launchURL(bannerController.storeBannerList![index].defaultLink.toString());
                                      }
                                    },
                                    child: Text(bannerController.storeBannerList![index].defaultLink == null ? 'N/A' : bannerController.storeBannerList![index].defaultLink.toString(),
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: bannerController.storeBannerList![index].defaultLink != null ? Colors.blue : Theme.of(context).disabledColor),
                                    ),
                                  ),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                Wrap(crossAxisAlignment: WrapCrossAlignment.center, runAlignment: WrapAlignment.center, children: [
                                  Text('${'title'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Text(bannerController.storeBannerList![index].title.toString(), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                ]),
                              ],
                            )),

                            InkWell(
                              onTap: (){
                                Get.toNamed(RouteHelper.getAddBannerRoute(storeBannerListModel: bannerController.storeBannerList![index], isUpdate: true));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.blue, size: 15,),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            InkWell(
                              onTap: (){
                                Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_delete_this_banner'.tr,
                                  onYesPressed: () {
                                  if(bannerController.storeBannerList![index].id != null) {
                                    bannerController.deleteBanner(bannerController.storeBannerList![index].id);
                                  }
                                }), useSafeArea: false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).colorScheme.error),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 15),
                              ),
                            ),

                          ]),
                        ]),
                      );
                    },
                  ) : Center(child: Text('no_banner_found'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))) : const Center(child: CircularProgressIndicator());
                }
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: GetBuilder<BannerController>(builder: (bannerController) {
                return CustomButtonWidget(
                  onPressed: () => Get.toNamed(RouteHelper.getAddBannerRoute(storeBannerListModel: null, isUpdate: false)),
                  buttonText: 'add_new_banner'.tr,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

}
