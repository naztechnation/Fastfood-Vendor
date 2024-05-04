import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  final bool success;
  final bool isWalletPayment;
  const PaymentSuccessfulScreen({super.key, required this.success, required this.isWalletPayment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBarWidget(title: '', isBackButtonExist: false),

      body: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(success ? Images.checked : Images.warning, width: 100, height: 100, color: success ? Colors.green : Colors.red),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          success ? 'your_payment_is_successfully_placed'.tr : 'your_payment_is_not_done'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(buttonText: 'okay'.tr, onPressed: () {
            if(isWalletPayment) {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            }else {
              Get.offAllNamed(RouteHelper.getSignInRoute());
            }
          }),
        ),

      ])),

    );
  }
}
