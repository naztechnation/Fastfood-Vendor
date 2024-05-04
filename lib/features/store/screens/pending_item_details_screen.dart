import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/widgets/information_text_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/title_tag_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/variation_view_for_foood_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/variation_view_for_general_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';

class PendingItemDetailsScreen extends StatefulWidget {
  final int id;
  const PendingItemDetailsScreen({super.key, required this.id});

  @override
  State<PendingItemDetailsScreen> createState() => _PendingItemDetailsScreenState();
}

class _PendingItemDetailsScreenState extends State<PendingItemDetailsScreen> with SingleTickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    Get.find<StoreController>().getPendingItemDetails(widget.id, canUpdate: false);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
        appBar: AppBar(
            title: Column(children: [
              Text('item_details'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(storeController.pendingItem![0].isRejected == 0 ? 'this_item_is_under_review'.tr : 'this_item_has_been_rejected'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: storeController.pendingItem![0].isRejected  == 0 ? Colors.blue : Theme.of(context).colorScheme.error)),
            ]),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => Get.back(),
            ),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0.4,
          actions: [
            storeController.item != null ? IconButton(
              onPressed: () => Get.find<StoreController>().deleteItem(storeController.item!.id, pendingItem: true),
              icon: Icon(CupertinoIcons.delete_simple, color: Theme.of(context).colorScheme.error),
            ) : const SizedBox(),
          ],
        ),

        body: storeController.item != null
         ? EnglishLanguageItemTab(item: storeController.item!,storeController: storeController) : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}

class EnglishLanguageItemTab extends StatelessWidget {
  final Item item;
  final StoreController storeController;
  const EnglishLanguageItemTab({super.key, required this.item, required this.storeController});

  @override
  Widget build(BuildContext context) {

    final List<Language>? languageList = Get.find<SplashController>().configModel!.language;
    String itemName = '';
    String itemDescription = '';
    for(Translation translation in item.translations!){
      if(translation.locale == languageList![storeController.languageSelectedIndex].key){
        if(translation.key == 'name') {
          itemName = translation.value!;
        }
        if(translation.key == 'description') {
          itemDescription = translation.value!;
        }
      }
    }
    Module? module = Get.find<SplashController>().configModel!.moduleConfig!.module;

    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        SizedBox(
          height: 40,
          child: ListView.builder(
            itemCount: languageList!.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              bool selected = index == storeController.languageSelectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () => storeController.setLanguageSelect(index),
                  child: Column(children: [
                    Text(
                      languageList[index].value!,
                      style: selected ? robotoBold.copyWith(color: Theme.of(context).primaryColor) : robotoMedium,
                    ),
                    Container(
                      height: 2, width: 100,
                      color: selected ? Theme.of(context).primaryColor : Colors.transparent,
                      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    ),

                  ]),
                ),
              );
            },
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                color: Theme.of(context).cardColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 90, width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        Container(
                          height: 70, width: 70,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).disabledColor.withOpacity(0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${item.image}',
                              fit: BoxFit.cover, width: 70, height: 70,
                            ),
                          ),
                        ),

                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(itemName, maxLines: 2, overflow: TextOverflow.ellipsis, style: robotoMedium),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(storeController.pendingItem![0].isRejected == 0 ? 'this_item_is_under_review'.tr : 'this_item_has_been_rejected'.tr,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: storeController.pendingItem![0].isRejected  == 0 ? Colors.blue : Theme.of(context).colorScheme.error)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),

                  Text(
                    itemDescription,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Column(children: [
                TitleTagWidget(title: 'general_information'.tr),

                InformationTextWidget(
                  title: 'store'.tr,
                  value: item.storeName.toString(),
                ),

                InformationTextWidget(
                  title: 'category'.tr,
                  value: item.categoryIds![0].name.toString(),
                ),

                item.categoryIds!.length > 1 ? InformationTextWidget(
                  title: 'sub_category'.tr,
                  value: item.categoryIds![1].name.toString(),
                ) : const SizedBox(),

                InformationTextWidget(
                  title: storeController.isFoodModule() ? 'available_time'.tr : 'total_stock'.tr,
                  value: storeController.isFoodModule() ? '${item.availableTimeStarts} - ${item.availableTimeEnds}' : item.stock.toString(),
                ),

                item.unitType != null ? InformationTextWidget(
                  title: 'product_unit'.tr,
                  value: item.unitType!,
                ) : const SizedBox(),

                InformationTextWidget(
                  title: storeController.isFoodModule() ? 'item_type'.tr : 'is_organic'.tr,
                  value: storeController.isFoodModule() ? item.veg == 1 ? 'veg'.tr : 'non_veg'.tr : item.veg == 1 ? 'yes'.tr : 'no'.tr,
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Column(children: [
                TitleTagWidget(title: 'price_information'.tr),

                InformationTextWidget(
                  title: 'unit_price'.tr,
                  value: PriceConverterHelper.convertPrice(item.price!),
                ),

                InformationTextWidget(
                  title: 'tax'.tr,
                  value: '${item.tax.toString()} %',
                ),

                InformationTextWidget(
                  title: 'discount'.tr,
                  value: item.discountType != 'percent' ? PriceConverterHelper.convertPrice(item.discount) : '${item.discount.toString()} %'
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),


              (item.foodVariations != null && item.foodVariations!.isNotEmpty) || (item.variations != null && item.variations!.isNotEmpty) ? Column(children: [
                TitleTagWidget(title: 'available_variation'.tr),

                Get.find<SplashController>().getStoreModuleConfig().newVariation! ? VariationViewForFood(item: item)
                    : VariationViewForGeneral(item: item, stock: module!.stock),
              ]) : const SizedBox(),
              SizedBox(height: (item.foodVariations != null && item.foodVariations!.isNotEmpty) || (item.variations != null && item.variations!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),


              (item.addOns!.isNotEmpty && module!.addOn!) ? Column(children: [
                TitleTagWidget(title: 'addons'.tr),

                (item.addOns!.isNotEmpty && module.addOn!) ? ListView.builder(
                  itemCount: item.addOns!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InformationTextWidget(
                      title: item.addOns![index].name!,
                      value: PriceConverterHelper.convertPrice(item.addOns![index].price),
                    );
                  },
                ) : const SizedBox(),
              ]) : const SizedBox(),
              SizedBox(height: (item.addOns!.isNotEmpty && module!.addOn!) ? Dimensions.paddingSizeSmall : 0),

              (item.tags != null && item.tags!.isNotEmpty) ? Column(children: [
                TitleTagWidget(title: 'tags'.tr),

                (item.tags != null && item.tags!.isNotEmpty) ? Container(
                  height: 35,
                  width: context.width,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  color: Theme.of(context).cardColor,
                  child: ListView.builder(
                    itemCount: item.tags!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Wrap(
                        children: [
                          Text(item.tags![index].tag!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        ],
                      );
                    },
                  ),
                ) : const SizedBox(),
              ]) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeSmall),

            ]),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              onPressed: () => Get.toNamed(RouteHelper.getItemRoute(item)),
              buttonText: 'edit_and_resubmit'.tr,
            ),
          ),
        ),
      ],
    );
  }
}
