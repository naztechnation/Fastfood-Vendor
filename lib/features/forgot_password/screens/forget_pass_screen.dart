import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/forgot_password/controllers/forgot_password_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'forgot_password'.tr),
      body: SafeArea(child: Center(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Text('please_enter_email'.tr, style: robotoRegular, textAlign: TextAlign.center),
          const SizedBox(height: 50),

          CustomTextFieldWidget(
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.done,
            hintText: 'email'.tr,
            prefixImage: Images.mail,
            onSubmit: (text) => GetPlatform.isWeb ? _forgetPass() : null,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButtonWidget(
              buttonText: 'next'.tr,
              onPressed: () => _forgetPass(),
            ) : const Center(child: CircularProgressIndicator());
          }),

        ]))),
      ))),
    );
  }

  void _forgetPass() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else {
      Get.find<ForgotPasswordController>().forgetPassword(email).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(email));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
