import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/language/widgets/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  final bool fromMenu;
  const LanguageScreen({super.key, required this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fromMenu ? CustomAppBarWidget(title: 'language'.tr) : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [

            Expanded(child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Center(child: SizedBox(
                  width: 1170,
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Center(child: Image.asset(Images.logo, width: 200)),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text('select_language'.tr, style: robotoMedium),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                          childAspectRatio: (1/1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController, index: index,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('you_can_change_language'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                    )),

                  ]),
                )),
              ),
            )),

            CustomButtonWidget(
              buttonText: 'save'.tr,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              onPressed: () {
                if(localizationController.languages.isNotEmpty && localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex].languageCode!,
                    AppConstants.languages[localizationController.selectedIndex].countryCode,
                  ));
                  if (fromMenu) {
                    Navigator.pop(context);
                  } else {
                    Get.find<SplashController>().setIntro(false);
                    Get.offNamed(RouteHelper.getSignInRoute());
                  }
                }else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ]);
        }),
      ),
    );
  }
}