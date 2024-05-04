import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/helper/url_validator.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';

class AddBannerScreen extends StatefulWidget {
final StoreBannerListModel? storeBannerListModel;
final bool? isUpdate;
const AddBannerScreen({super.key, this.storeBannerListModel, this.isUpdate});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    Get.find<StoreController>().pickImage(true, true);

    if(widget.isUpdate!) {
      _titleController.text = widget.storeBannerListModel!.title ?? '';
      _urlController.text = widget.storeBannerListModel!.defaultLink ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.isUpdate! ? 'update_banner'.tr : 'add_banner'.tr),

      body: GetBuilder<BannerController>(builder: (bannerController) {
        return GetBuilder<StoreController>(builder: (storeController) {
          return Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('title'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextFieldWidget(
                      hintText: 'enter_title'.tr,
                      controller: _titleController,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text('redirection_url_link'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextFieldWidget(
                      hintText: 'enter_url'.tr,
                      controller: _urlController,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text('upload_banner'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    DottedBorder(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(Dimensions.radiusSmall),
                      child: SizedBox(
                        height: 125, width: Get.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: storeController.rawLogo != null ? GetPlatform.isWeb ? Image.network(
                                storeController.rawLogo!.path, width: Get.width, height: 125, fit: BoxFit.cover,
                              ) : Image.file(
                                File(storeController.rawLogo?.path ?? ''), width: Get.width, height: 125, fit: BoxFit.cover,
                              ) : widget.storeBannerListModel == null ? SizedBox(width: context.width, height: 125) : CustomImageWidget(
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl}/${widget.storeBannerListModel?.image ?? ''}',
                                height: 125, width: Get.width, fit: BoxFit.cover,
                              ),
                            ),

                            Positioned(
                              right: 0, left: 0, top: 0, bottom: 0,
                              child: InkWell(
                                onTap: () => storeController.pickImage(true, false),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  const Icon(Icons.cloud_upload, color: Colors.teal),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Text(
                                    "drag_drop_file_or_browse_file".tr,
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),
                              ),
                            ),

                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          "banner_images_ration_5:1".tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          "image_format_maximum_size_2mb".tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor.withOpacity(0.5)),
                      ),
                    ),

                  ]),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: !bannerController.isLoading ? CustomButtonWidget(
                  onPressed: () {
                    if(widget.isUpdate!) {
                      if(_titleController.text.isEmpty) {
                        showCustomSnackBar('enter_title'.tr);
                      }else if((UrlValidator.isValidUrl(_urlController.text) && _urlController.text.isNotEmpty)) {
                        showCustomSnackBar('enter_valid_url'.tr);
                      }else {
                        bannerController.updateBanner(widget.storeBannerListModel!.id, _titleController.text, _urlController.text, storeController.rawLogo);
                      }
                      return;
                    }else{
                      if(_titleController.text.isEmpty) {
                        showCustomSnackBar('enter_title'.tr);
                      }else if((UrlValidator.isValidUrl(_urlController.text) && _urlController.text.isNotEmpty)) {
                        showCustomSnackBar('enter_valid_url'.tr);
                      }else if(storeController.rawLogo == null) {
                        showCustomSnackBar('upload_banner'.tr);
                      }else {
                        bannerController.addBanner(_titleController.text, _urlController.text, storeController.rawLogo!);
                      }
                    }
                  },
                  buttonText: widget.isUpdate! ? 'update_banner'.tr : 'add_banner'.tr,
                ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ]);
        });
      }),
    );
  }
}
