import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/features/home/widgets/order_button_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/count_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/order_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().getPaginatedOrders(1, true);

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'order_history'.tr, isBackButtonExist: false),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return Get.find<ProfileController>().modulePermission!.order! ? Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(children: [

            GetBuilder<ProfileController>(builder: (profileController) {
              return profileController.profileModel != null ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Row(children: [
                  CountWidget(title: 'today'.tr, count: profileController.profileModel!.todaysOrderCount),
                  CountWidget(title: 'this_week'.tr, count: profileController.profileModel!.thisWeekOrderCount),
                  CountWidget(title: 'this_month'.tr, count: profileController.profileModel!.thisMonthOrderCount),
                ]),
              ) : const SizedBox();
            }),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderController.statusList.length,
                itemBuilder: (context, index) {
                  return OrderButtonWidget(
                    title: orderController.statusList[index].tr, index: index, orderController: orderController, fromHistory: true,
                  );
                },
              ),
            ),
            SizedBox(height: orderController.historyOrderList != null ? Dimensions.paddingSizeSmall : 0),

            Expanded(
              child: orderController.historyOrderList != null ? orderController.historyOrderList!.isNotEmpty
                  ? const OrderViewWidget() : Center(child: Text('no_order_found'.tr)) : const Center(child: CircularProgressIndicator()),
            ),

          ]),
        ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
      }),
    );
  }
}
