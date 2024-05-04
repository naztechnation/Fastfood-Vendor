import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/features/payment/widgets/payment_method_bottom_sheet_widget.dart';

class WalletAttentionAlertWidget extends StatelessWidget {
  final bool isOverFlowBlockWarning;
  const WalletAttentionAlertWidget({super.key, required this.isOverFlowBlockWarning});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Container(
          width: context.width * 0.95,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: const Color(0xfffff1f1),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [

              Image.asset(Images.attentionWarningIcon, width: 20, height: 20),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('attention_please'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black)),

            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            isOverFlowBlockWarning ? RichText(
              text: TextSpan(
                text: '${'over_flow_block_warning_message'.tr}  ',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      if(profileController.profileModel!.showPayNowButton!) {
                        showModalBottomSheet(
                          isScrollControlled: true, useRootNavigator: true, context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                          ),
                          builder: (context) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                              child: const PaymentMethodBottomSheetWidget(isWalletPayment: true),
                            );
                          },
                        );
                      } else {
                        if(Get.find<SplashController>().configModel!.activePaymentMethodList!.isEmpty || !Get.find<SplashController>().configModel!.digitalPayment!){
                          showCustomSnackBar('currently_there_are_no_payment_options_available_please_contact_admin_regarding_any_payment_process_or_queries'.tr);
                        }else if(Get.find<SplashController>().configModel!.minAmountToPayStore! > profileController.profileModel!.cashInHands!){
                          showCustomSnackBar('${'you_do_not_have_sufficient_balance_to_pay_the_minimum_payable_balance_is'.tr} ${PriceConverterHelper.convertPrice(Get.find<SplashController>().configModel!.minAmountToPayStore)}');
                        }
                      }
                    },
                    text: 'pay_the_due'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ) : Text('over_flow_warning_message'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black)),
          ]),
        );
      }
    );
  }
}