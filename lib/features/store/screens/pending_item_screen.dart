import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/edit_button_widget.dart';

class PendingItemScreen extends StatefulWidget {
  const PendingItemScreen({super.key});

  @override
  State<PendingItemScreen> createState() => _PendingItemScreenState();
}

class _PendingItemScreenState extends State<PendingItemScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    Get.find<StoreController>().getPendingItemList(
      Get.find<StoreController>().offset.toString(), Get.find<StoreController>().type, canNotify: false,
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'pending_for_approval'.tr),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<StoreController>().getPendingItemList(
            Get.find<StoreController>().offset.toString(), Get.find<StoreController>().type, canNotify: false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: GetBuilder<StoreController>(builder: (storeController) {
              return Column(children: [

                Row(children: [

                  Expanded(
                    child: Text('new_product'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),
                  const SizedBox(width: 40),

                  PopupMenuButton(

                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        getMenuItem(Get.find<StoreController>().statusList[0], context),
                        const PopupMenuDivider(),
                        getMenuItem(Get.find<StoreController>().statusList[1], context),
                        const PopupMenuDivider(),
                        getMenuItem(Get.find<StoreController>().statusList[2], context),
                      ];
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.filter_list_sharp, color: Theme.of(context).textTheme.bodyLarge!.color, size: 20),
                    ),

                    onSelected: (dynamic value) {
                      int index = Get.find<StoreController>().statusList.indexOf(value);
                      Get.find<StoreController>().getPendingItemList(
                        Get.find<StoreController>().offset.toString(), Get.find<StoreController>().statusList[index],
                      );
                    },
                  ),
                ]),

                Expanded(
                  child: storeController.pendingItem != null ? storeController.pendingItem!.isNotEmpty ? ListView.builder(
                    itemCount: storeController.pendingItem!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.getPendingItemDetailsRoute(storeController.pendingItem![index].id!));
                      },
                      child: Container(
                        height: 90, width: double.infinity,
                        margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 0))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
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
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${storeController.pendingItem![index].image}',
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

                                  Text(storeController.pendingItem![index].name.toString(), style: robotoMedium),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Row(children: [
                                    Text('${'category'.tr} : ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                                    Text(storeController.pendingItem![index].categoryIds![index].name.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  ]),

                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Text(PriceConverterHelper.convertPrice(storeController.pendingItem![index].price), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                                ],
                              ),
                            ),

                            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [

                              Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  color: storeController.pendingItem![index].isRejected  == 0 ? Colors.blue.withOpacity(0.1) : Theme.of(context).colorScheme.error.withOpacity(0.1),
                                ),
                                child: Text(
                                  storeController.pendingItem![index].isRejected  == 0 ? 'pending'.tr : 'rejected'.tr,
                                  style: robotoMedium.copyWith(
                                    color: storeController.pendingItem![index].isRejected  == 0 ? Colors.blue : Theme.of(context).colorScheme.error,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),

                              EditButtonWidget(
                                onTap: () async{
                                  await storeController.getPendingItemDetails(storeController.pendingItem![index].id!).then((success) {
                                    if(success){
                                      Get.toNamed(RouteHelper.getItemRoute(storeController.item));
                                    }
                                  });
                                },
                              ),
                            ]),

                          ]),
                        ),
                      ),
                    ),
                  ) : Center(child: Text('no_item_available'.tr)) :  const Center(child: CircularProgressIndicator()),

                ),
              ]);
            }
          ),
        ),
      ),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'pending' ? Theme.of(context).primaryColor : status == 'rejected' ? Theme.of(context).colorScheme.error : null,
      )),
    );
  }
}