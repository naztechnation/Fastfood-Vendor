import 'package:sixam_mart_store/common/widgets/rating_bar_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/discount_tag_widget.dart';
import 'package:sixam_mart_store/common/widgets/not_available_widget.dart';
import 'package:sixam_mart_store/features/store/screens/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  const ItemWidget({super.key, required this.item, required this.index,
   required this.length, this.inStore = false, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    discount = (item.storeDiscount == 0 || isCampaign) ? item.discount : item.storeDiscount;
    discountType = (item.storeDiscount == 0 || isCampaign) ? item.discountType : 'percent';
    isAvailable = DateConverterHelper.isAvailable(item.availableTimeStarts, item.availableTimeEnds);

    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getItemDetailsRoute(item), arguments: ItemDetailsScreen(item: item)),
      child: Container(
        padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
            child: Row(children: [

              item.image != null ? Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: '${isCampaign ? baseUrls!.campaignImageUrl : baseUrls!.itemImageUrl}/${item.image}',
                    height: desktop ? 120 : 65, width: desktop ? 120 : 80, fit: BoxFit.cover,
                  ),
                ),
                DiscountTagWidget(
                  discount: discount, discountType: discountType,
                  freeDelivery: false,
                ),
                isAvailable ? const SizedBox() : const NotAvailableWidget(isStore: false),
              ]) : const SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Text(
                      item.name!,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                    ),

                    item.image == null ? Text(
                      '(${discount! > 0 ? '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'off'.tr}' : 'free_delivery'.tr})',
                      style: robotoMedium.copyWith(color: Colors.green, fontSize: Dimensions.fontSizeExtraSmall),
                    ) : const SizedBox(),
                  ]),
                  SizedBox(height: item.image != null ? Dimensions.paddingSizeExtraSmall : 0),

                  Row(children: [
                    RatingBarWidget(
                      rating: item.avgRating, size: desktop ? 15 : 12,
                      ratingCount: item.ratingCount,
                    ),

                    item.image == null && !isAvailable ? Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        '(${'not_available_now'.tr})', textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(color: Colors.red, fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    ) : const SizedBox(),
                  ]),

                  Row(children: [

                    Text(
                      PriceConverterHelper.convertPrice(item.price, discount: discount, discountType: discountType),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                    discount > 0 ? Text(
                      PriceConverterHelper.convertPrice(item.price),
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ) : const SizedBox(),

                  ]),

                ]),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
                    Get.find<StoreController>().getItemDetails(item.id!).then((itemDetails) {
                      if(itemDetails != null){
                        Get.toNamed(RouteHelper.getItemRoute(itemDetails));
                      }
                    });
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
                    Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, description: 'are_you_sure_want_to_delete_this_product'.tr,
                      onYesPressed: () => Get.find<StoreController>().deleteItem(item.id),
                    ));
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              ),

            ]),
          )),

          desktop ? const SizedBox() : Padding(
            padding: EdgeInsets.only(left: desktop ? 130 : 90),
            child: Divider(color: index == length-1 ? Colors.transparent : Theme.of(context).disabledColor),
          ),

        ]),
      ),
    );
  }
}
