import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/widgets/pass_view_widget.dart';
import 'package:sixam_mart_store/features/forgot_password/controllers/forgot_password_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? email;
  final bool fromPasswordChange;
  const NewPassScreen({super.key, required this.resetToken, required this.email, required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr),
      body: SafeArea(child: Center(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Text('enter_new_password'.tr, style: robotoRegular, textAlign: TextAlign.center),
          const SizedBox(height: 50),

          GetBuilder<AuthController>(builder: (authController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor,
                boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
              ),
              child: Column(children: [

                CustomTextFieldWidget(
                  hintText: 'new_password'.tr,
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocus,
                  nextFocus: _confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  iconSize: 24,
                  isPassword: true,
                  onChanged: (value){
                    if(value != null && value.isNotEmpty){
                      if(!authController.showPassView){
                        authController.showHidePass();
                      }
                      authController.validPassCheck(value);
                    }else{
                      if(authController.showPassView){
                        authController.showHidePass();
                      }
                    }
                  },
                ),
                authController.showPassView ? const PassViewWidget() : const SizedBox(),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                CustomTextFieldWidget(
                  hintText: 'confirm_password'.tr,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  iconSize: 24,
                  isPassword: true,
                  onSubmit: (text) => GetPlatform.isWeb ? _resetPassword(authController) : null,
                ),

              ]),
            );
          }),
          const SizedBox(height: 30),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButtonWidget(
              buttonText: 'done'.tr,
              onPressed: () => _resetPassword(authController),
            ) : const Center(child: CircularProgressIndicator());
          }),

        ]))),
      ))),
    );
  }

  void _resetPassword(AuthController authController) {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 8) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(password != confirmPassword) {
      showCustomSnackBar('password_does_not_matched'.tr);
    }else if(!authController.spatialCheck || !authController.lowercaseCheck || !authController.uppercaseCheck || !authController.numberCheck || !authController.lengthCheck){
      showCustomSnackBar('provide_valid_password'.tr);
    }else {
      if(widget.fromPasswordChange) {
        ProfileModel user = Get.find<ProfileController>().profileModel!;
        Get.find<ForgotPasswordController>().changePassword(user, password);
      }else {
        Get.find<ForgotPasswordController>().resetPassword(widget.resetToken, widget.email, password, confirmPassword).then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login(widget.email, password, 'owner').then((value) async {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
