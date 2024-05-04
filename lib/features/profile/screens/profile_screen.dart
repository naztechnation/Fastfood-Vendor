import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/switch_button_widget.dart';
import 'package:sixam_mart_store/features/profile/widgets/profile_bg_widget.dart';
import 'package:sixam_mart_store/features/profile/widgets/profile_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isOwner;

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().getProfile();
    _isOwner = Get.find<AuthController>().getUserType() == 'owner';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return profileController.profileModel == null ? const Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: true,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: CustomImageWidget(
              image: _isOwner ? '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}'
                  '/${profileController.profileModel != null ? profileController.profileModel!.image : ''}'
                  : '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}/${profileController.profileModel!.image}',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
          ),
          mainWidget: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Center(child: Container(
            width: 1170, color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              _isOwner ? Text(
                '${profileController.profileModel!.fName} ${profileController.profileModel!.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ) : Text(
                '${profileController.profileModel!.employeeInfo!.fName} ${profileController.profileModel!.employeeInfo!.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 30),

              Row(children: [
                _isOwner ? ProfileCardWidget(title: 'since_joining'.tr, data: '${profileController.profileModel!.memberSinceDays} ${'days'.tr}') : const SizedBox(),
                SizedBox(width: Get.find<ProfileController>().modulePermission!.order! && _isOwner ? Dimensions.paddingSizeSmall : 0),
                Get.find<ProfileController>().modulePermission!.order! ? ProfileCardWidget(title: 'total_order'.tr, data: profileController.profileModel!.orderCount.toString()) : const SizedBox(),
              ]),
              const SizedBox(height: 30),

              SwitchButtonWidget(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SwitchButtonWidget(
                icon: Icons.notifications, title: 'notification'.tr,
                isButtonActive: Get.find<AuthController>().notification, onTap: () {
                Get.find<AuthController>().setNotificationActive(!Get.find<AuthController>().notification);
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _isOwner ? SwitchButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeSmall : 0),

              _isOwner ? SwitchButtonWidget(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeSmall : 0),

              _isOwner ? SwitchButtonWidget(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(ConfirmationDialogWidget(icon: Images.warning, title: 'are_you_sure_to_delete_account'.tr,
                    description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                    onYesPressed: () => profileController.deleteVendor()),
                    useSafeArea: false,
                  );
                },
              ) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeLarge : 0),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(AppConstants.appVersion.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}