import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';

class PaymentMethodBottomSheetWidget extends StatefulWidget {
  final bool isWalletPayment;
  const PaymentMethodBottomSheetWidget({super.key, this.isWalletPayment = false});

  @override
  State<PaymentMethodBottomSheetWidget> createState() => _PaymentMethodBottomSheetWidgetState();
}

class _PaymentMethodBottomSheetWidgetState extends State<PaymentMethodBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge),
          topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<PaymentController>(builder: (paymentController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Align(alignment: Alignment.center, child: Text('payment_method'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(children: [

              Text('pay_via_online'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

              Flexible(
                child: Text(
                  '(${'faster_and_secure_way_to_pay_bill'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),

            ]),

          ]),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  bool isSelected = paymentController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == paymentController.digitalPaymentName;
                  return InkWell(
                    onTap: (){
                      paymentController.setPaymentIndex(1);
                      paymentController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.4)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                      child: Row(children: [
                        Container(
                          height: 20, width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: isSelected ? Colors.green : Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).disabledColor)
                          ),
                          child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Text(
                          Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                        ),
                        const Spacer(),

                        CustomImageWidget(
                          height: 20, fit: BoxFit.contain,
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.gatewayImageUrl}/${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImage}',
                        ),

                      ]),
                    ),
                  );
                },
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: CustomButtonWidget(
                radius: Dimensions.radiusDefault,
                buttonText: 'select'.tr,
                onPressed: () {
                  if(widget.isWalletPayment) {
                    double amount = Get.find<ProfileController>().profileModel!.cashInHands!;
                    Get.find<PaymentController>().makeCollectCashPayment(amount, Get.find<PaymentController>().digitalPaymentName!);
                  }else {
                    Get.back();
                  }
                }
              ),
            ),
          ),

        ]);
      }),
    );
  }
}
