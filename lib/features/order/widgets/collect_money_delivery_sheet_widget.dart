import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectMoneyDeliverySheetWidget extends StatelessWidget {
  final int? orderID;
  final bool? verify;
  final bool cod;
  final double? orderAmount;
  const CollectMoneyDeliverySheetWidget({super.key, required this.orderID, required this.verify, required this.orderAmount, required this.cod});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).disabledColor,
              ),
            ),

            cod ? Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Image.asset(Images.deliveredSuccess, height: 100, width: 100),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                'collect_money_from_customer'.tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '${'order_amount'.tr}:', textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  PriceConverterHelper.convertPrice(orderAmount), textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ),
              ]),
              SizedBox(height: verify! ? 20 : 40),
            ]) : const SizedBox(),

            !orderController.isLoading ? CustomButtonWidget(
              buttonText: 'ok'.tr,
              radius: Dimensions.radiusDefault,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              onPressed: () {
                if(verify!) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.find<OrderController>().updateOrderStatus(orderID, 'delivered').then((success) {
                    if(success) {
                      Get.find<ProfileController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                      Get.offAllNamed(RouteHelper.getInitialRoute());
                    }
                  });
                }
              },
            ) : const Center(child: CircularProgressIndicator()),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        );
      }),
    );
  }
}
