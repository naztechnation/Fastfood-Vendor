import 'package:sixam_mart_store/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/wallet_attention_alert_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/wallet_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/withdraw_request_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/payment/widgets/withdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  void initState() {
    Get.find<PaymentController>().getWithdrawList();
    Get.find<PaymentController>().getWithdrawMethodList();
    Get.find<PaymentController>().getWalletPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'wallet'.tr, isBackButtonExist: false),

      body: GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<PaymentController>(builder: (bankController) {
          return profileController.modulePermission!.wallet! ? (profileController.profileModel != null && bankController.withdrawList != null) ? RefreshIndicator(
            onRefresh: () async {
              await Get.find<ProfileController>().getProfile();
              await Get.find<PaymentController>().getWithdrawList();
            },
            child: Column(children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Row(children: [

                        Image.asset(Images.wallet, width: 60, height: 60),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            profileController.profileModel!.dynamicBalanceType!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text(
                            PriceConverterHelper.convertPrice(profileController.profileModel!.dynamicBalance!),
                            style: robotoBold.copyWith(fontSize: 22, color: Theme.of(context).cardColor),
                            textDirection: TextDirection.ltr,
                          ),

                        ])),

                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          profileController.profileModel!.adjustable! ? InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GetBuilder<PaymentController>(builder: (paymentController) {
                                    return AlertDialog(
                                      title: Center(child: Text('cash_adjustment'.tr)),
                                      content: Text('cash_adjustment_description'.tr, textAlign: TextAlign.center),
                                      actions: [

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(children: [

                                            Expanded(
                                              child: CustomButtonWidget(
                                                onPressed: () => Get.back(),
                                                color: Theme.of(context).disabledColor.withOpacity(0.5),
                                                buttonText: 'cancel'.tr,
                                              ),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  bankController.makeWalletAdjustment();
                                                },
                                                child: Container(
                                                  height: 45,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                  child: !paymentController.adjustmentLoading ? Text('ok'.tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),)
                                                      : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                                                ),
                                              ),
                                            ),

                                          ]),
                                        ),

                                      ],
                                    );
                                  });
                                }
                              );
                            },
                            child: Container(
                              width: 115,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Text('adjust_payments'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),
                          SizedBox(height: profileController.profileModel!.adjustable! ? Dimensions.paddingSizeLarge : 0),

                          (profileController.profileModel!.balance! > 0 && profileController.profileModel!.balance! > profileController.profileModel!.cashInHands! && Get.find<SplashController>().configModel!.disbursementType == 'manual') ? InkWell(
                            onTap: () {
                              Get.bottomSheet(const WithdrawRequestBottomSheetWidget(), isScrollControlled: true);
                            },
                            child: Container(
                              width: profileController.profileModel!.adjustable! ? 115 : null,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Text('withdraw'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),
                          SizedBox(height: (profileController.profileModel!.balance! > 0 && profileController.profileModel!.balance! > profileController.profileModel!.cashInHands! && Get.find<SplashController>().configModel!.disbursementType == 'manual') ? Dimensions.paddingSizeSmall : 0),

                          (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!) ? InkWell(
                            onTap: () {
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
                            child: Container(
                              width: profileController.profileModel!.adjustable! ? 115 : null,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: profileController.profileModel!.showPayNowButton! ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withOpacity(0.8),
                              ),
                              child: Text('pay_now'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),

                        ]),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(children: [

                      Expanded(child: WalletWidget(title: 'cash_in_hand'.tr, value: profileController.profileModel!.cashInHands)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: WalletWidget(title: 'withdrawable_balance'.tr, value: profileController.profileModel!.balance)),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'pending_withdraw'.tr, value: profileController.profileModel!.pendingWithdraw, isAmountAndTextInRow: true),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'already_withdrawn'.tr, value: profileController.profileModel!.alreadyWithdrawn, isAmountAndTextInRow: true),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'total_earning'.tr, value: profileController.profileModel!.totalEarning , isAmountAndTextInRow: true),

                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                      child: Row(children: [

                        InkWell(
                          onTap: () {
                            if(bankController.selectedIndex != 0) {
                              bankController.setIndex(0);
                            }
                          },
                          hoverColor: Colors.transparent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('withdraw_request'.tr, style: robotoMedium.copyWith(
                              color: bankController.selectedIndex == 0 ? Colors.blue : Theme.of(context).disabledColor,
                            )),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Container(
                              height: 3, width: 120,
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: bankController.selectedIndex == 0 ? Colors.blue : null,
                              ),
                            ),

                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: () {
                            if(bankController.selectedIndex != 1) {
                              bankController.setIndex(1);
                            }
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('payment_history'.tr, style: robotoMedium.copyWith(
                              color: bankController.selectedIndex == 1 ? Colors.blue : Theme.of(context).disabledColor,
                            )),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Container(
                              height: 3, width: 120,
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: bankController.selectedIndex == 1 ? Colors.blue : null,
                              ),
                            ),

                          ]),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Text("transaction_history".tr, style: robotoMedium),

                      (bankController.selectedIndex == 0 && bankController.withdrawList!.isEmpty)
                      || (bankController.selectedIndex == 1 && bankController.transactions!.isEmpty) ? const SizedBox() : InkWell(
                        onTap: () {
                          if(bankController.selectedIndex == 0) {
                            Get.toNamed(RouteHelper.getWithdrawHistoryRoute());
                          }
                          if(bankController.selectedIndex == 1) {
                            Get.toNamed(RouteHelper.getPaymentHistoryRoute());
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text('view_all'.tr, style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                          )),
                        ),
                      ),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    if(bankController.selectedIndex == 0)
                      bankController.withdrawList != null ? bankController.withdrawList!.isNotEmpty ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bankController.withdrawList!.length > 10 ? 10 : bankController.withdrawList!.length,
                        itemBuilder: (context, index) {
                          return WithdrawWidget(
                            withdrawModel: bankController.withdrawList![index],
                            showDivider: index != (bankController.withdrawList!.length > 25 ? 25 : bankController.withdrawList!.length-1),
                          );
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 70), child: Text('no_transaction_found'.tr)))
                          : const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator())),

                    if (bankController.selectedIndex == 1)
                      bankController.transactions != null ? bankController.transactions!.isNotEmpty ? ListView.builder(
                        itemCount: bankController.transactions!.length > 25 ? 25 : bankController.transactions!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                              child: Row(children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(PriceConverterHelper.convertPrice(bankController.transactions![index].amount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Text('${'paid_via'.tr} ${bankController.transactions![index].method?.replaceAll('_', ' ').capitalize??''}', style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                    )),
                                  ]),
                                ),
                                Text(bankController.transactions![index].paymentTime.toString(),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),
                              ]),
                            ),

                            const Divider(height: 1),
                          ]);
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 70), child: Text('no_transaction_found'.tr)))
                          : const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator())),


                  ]),
                ),
              ),

              (profileController.profileModel!.overFlowWarning! || profileController.profileModel!.overFlowBlockWarning!)
                ? WalletAttentionAlertWidget(isOverFlowBlockWarning: profileController.profileModel!.overFlowBlockWarning!) : const SizedBox(),

            ]),
          ) : const Center(child: CircularProgressIndicator()) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
        });
      }),
    );
  }
}
