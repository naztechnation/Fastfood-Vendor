import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/add_bank_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'bank_info'.tr),

      body: GetBuilder<ProfileController>(builder: (profileController) {
        return Center(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: profileController.profileModel != null ? profileController.profileModel!.bankName != null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              InfoWidget(icon: Images.bank, title: 'bank_name'.tr, data: profileController.profileModel!.bankName),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InfoWidget(icon: Images.branch, title: 'branch_name'.tr, data: profileController.profileModel!.branch),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InfoWidget(icon: Images.user, title: 'holder_name'.tr, data: profileController.profileModel!.holderName),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InfoWidget(icon: Images.creditCard, title: 'account_no'.tr, data: profileController.profileModel!.accountNo),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              CustomButtonWidget(
                buttonText: 'edit'.tr,
                onPressed: () => Get.bottomSheet(AddBankBottomSheetWidget(
                  bankName: profileController.profileModel!.bankName, branchName: profileController.profileModel!.branch,
                  holderName: profileController.profileModel!.holderName, accountNo: profileController.profileModel!.accountNo,
                ), isScrollControlled: true, backgroundColor: Colors.transparent),
              ),

            ],
          ) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.bankInfo, width: context.width-100),
            const SizedBox(height: 30),

            Text(
              'currently_no_bank_account_added'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: 30),

            CustomButtonWidget(
              buttonText: 'add_bank'.tr,
              onPressed: () => Get.bottomSheet(const AddBankBottomSheetWidget(), isScrollControlled: true, backgroundColor: Colors.transparent),
            ),

          ]) : const Center(child: CircularProgressIndicator()),
        ));
      }),
    );
  }
}
