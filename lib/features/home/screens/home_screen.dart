import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/order_shimmer_widget.dart';
import 'package:sixam_mart_store/common/widgets/order_widget.dart';
import 'package:sixam_mart_store/features/home/widgets/order_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0, elevation: 0,
        title: Text(AppConstants.appName, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault,
        )),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {
            return Stack(children: [
              Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
              notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),
            ]);
          }),
          onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        )],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [

            GetBuilder<ProfileController>(builder: (profileController) {
              return Column(children: [
                Get.find<ProfileController>().modulePermission != null && Get.find<ProfileController>().modulePermission!.storeSetup! ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [
                    Expanded(child: Text(
                      Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                          ? 'restaurant_temporarily_closed'.tr : 'store_temporarily_closed'.tr, style: robotoMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    )),
                    profileController.profileModel != null ? Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: !profileController.profileModel!.stores![0].active!,
                        activeColor: Theme.of(context).primaryColor,
                        trackColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        onChanged: (bool isActive) {
                          bool? showRestaurantText = Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText;
                          Get.dialog(ConfirmationDialogWidget(
                            icon: Images.warning,
                            description: isActive ? showRestaurantText! ? 'are_you_sure_to_close_restaurant'.tr
                                : 'are_you_sure_to_close_store'.tr : showRestaurantText! ? 'are_you_sure_to_open_restaurant'.tr
                                : 'are_you_sure_to_open_store'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<AuthController>().toggleStoreClosedStatus();
                            },
                          ));
                        },
                      ),
                    ) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),
                  ]),
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                profileController.modulePermission!.wallet! ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'today'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.todaysEarning) : '0',
                          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                        ),
                      ]),
                    ]),
                    const SizedBox(height: 30),
                    Row(children: [
                      Expanded(child: Column(children: [
                        Text(
                          'this_week'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisWeekEarning) : '0',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                        ),
                      ])),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      Expanded(child: Column(children: [
                        Text(
                          'this_month'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisMonthEarning) : '0',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                        ),
                      ])),
                    ]),
                  ]),
                ) : const SizedBox(),
              ]);
            }),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            GetBuilder<OrderController>(builder: (orderController) {
              List<OrderModel> orderList = [];
              if(orderController.runningOrders != null) {
                orderList = orderController.runningOrders![orderController.orderIndex].orderList;
              }

              return Get.find<ProfileController>().modulePermission!.order! ? Column(children: [

                orderController.runningOrders != null ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderController.runningOrders!.length,
                    itemBuilder: (context, index) {
                      return OrderButtonWidget(
                        title: orderController.runningOrders![index].status.tr, index: index,
                        orderController: orderController, fromHistory: false,
                      );
                    },
                  ),
                ) : const SizedBox(),

                orderController.runningOrders != null ? InkWell(
                  onTap: () => orderController.toggleCampaignOnly(),
                  child: Row(children: [
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: orderController.campaignOnly,
                      onChanged: (isActive) => orderController.toggleCampaignOnly(),
                    ),
                    Text(
                      'campaign_order'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                  ]),
                ) : const SizedBox(),

                orderController.runningOrders != null ? orderList.isNotEmpty ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                  },
                ) : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: Text('no_order_found'.tr)),
                ) : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return OrderShimmerWidget(isEnabled: orderController.runningOrders == null);
                  },
                ),

              ]) : Center(child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
              ));
            }),

          ]),
        ),
      ),

    );
  }
}
