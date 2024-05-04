import 'dart:io';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/text_field_widget.dart';
import 'package:sixam_mart_store/features/profile/widgets/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }

    return Scaffold(
      body: GetBuilder<ProfileController>(builder: (profileController) {
        if(profileController.profileModel != null && _emailController.text.isEmpty) {
          _firstNameController.text = profileController.profileModel!.fName ?? '';
          _lastNameController.text = profileController.profileModel!.lName ?? '';
          _phoneController.text = profileController.profileModel!.phone ?? '';
          _emailController.text = profileController.profileModel!.email ?? '';
        }

        return profileController.profileModel != null ? ProfileBgWidget(
          backButton: true,
          circularImage: Center(child: Stack(children: [

            ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
              profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover) : Image.file(
              File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover) : FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${profileController.profileModel!.image}',
                height: 100, width: 100, fit: BoxFit.cover,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
            )),

            Positioned(
              bottom: 0, right: 0, top: 0, left: 0,
              child: InkWell(
                onTap: () => profileController.pickImage(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
            ),
          ])),
          mainWidget: Column(children: [

            Expanded(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                TextFieldWidget(
                  hintText: 'first_name'.tr,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  nextFocus: _lastNameFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                TextFieldWidget(
                  hintText: 'last_name'.tr,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  nextFocus: _phoneFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                TextFieldWidget(
                  hintText: 'phone'.tr,
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                TextFieldWidget(
                  hintText: 'email'.tr,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress,
                  isEnabled: false,
                ),

              ]))),
            )),

            !profileController.isLoading ? CustomButtonWidget(
              onPressed: () => _updateProfile(profileController),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              buttonText: 'update'.tr,
            ) : const Center(child: CircularProgressIndicator()),

          ]),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _updateProfile(ProfileController profileController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    if (profileController.profileModel!.fName == firstName &&
        profileController.profileModel!.lName == lastName && profileController.profileModel!.phone == phoneNumber &&
        profileController.profileModel!.email == _emailController.text && profileController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      ProfileModel updatedUser = ProfileModel(fName: firstName, lName: lastName, email: email, phone: phoneNumber);
      await profileController.updateUserInfo(updatedUser, Get.find<AuthController>().getUserToken());
    }
  }
}
