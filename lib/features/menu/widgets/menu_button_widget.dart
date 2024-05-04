import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/menu/domain/models/menu_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuButtonWidget extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  const MenuButtonWidget({super.key, required this.menu, required this.isProfile, required this.isLogout});

  @override
  Widget build(BuildContext context) {
    double size = (context.width/4)-Dimensions.paddingSizeDefault;

    return InkWell(
      onTap: () {
        if(menu.isBlocked) {
          showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
        }else {
          if (isLogout) {
            Get.back();
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                Get.find<AuthController>().clearSharedData();
                Get.offAllNamed(RouteHelper.getSignInRoute());
              }), useSafeArea: false);
            } else {
              Get.find<AuthController>().clearSharedData();
              Get.toNamed(RouteHelper.getSignInRoute());
            }
          } else {
            Get.offNamed(menu.route);
          }
        }
      },
      child: Column(children: [

        Container(
          height: size-(size*0.2),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: isLogout ? Get.find<AuthController>().isLoggedIn() ? Colors.red : Colors.green : Theme.of(context).primaryColor,
            boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
          ),
          alignment: Alignment.center,
          child: isProfile ? ProfileImageWidget(size: size) : Image.asset(menu.icon, width: size, height: size, color: Colors.white),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(menu.title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),

      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImageWidget(
            image: Get.find<AuthController>().getUserType() == 'owner' ? '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}'
                '/${(profileController.profileModel != null && Get.find<AuthController>().isLoggedIn()) ? profileController.profileModel!.image ?? '' : ''}'
            : '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${profileController.profileModel!.stores![0].logo}',
            width: size, height: size, fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}