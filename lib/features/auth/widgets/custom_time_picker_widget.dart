import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/auth/widgets/min_max_time_picker_widget.dart';

class CustomTimePickerWidget extends StatelessWidget {
  const CustomTimePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> time = [];
    for(int i = 1; i <= 60 ; i++){
      time.add(i.toString());
    }
    List<String> unit = ['minute'.tr, 'hours'.tr, 'days'.tr];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: GetBuilder<AuthController>(builder: (authController) {

          return Column(mainAxisSize: MainAxisSize.min, children: [

            Text('estimated_delivery_time'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text(
                'this_item_will_be_shown_in_the_user_app_website'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

              SizedBox(
                width: 70,
                child: Text(
                  'minimum'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(),

              SizedBox(
                width: 75,
                child: Text(
                  'maximum'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                width: 70,
                child: Text(
                  'unit'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),

            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

              MinMaxTimePickerWidget(
                times: time, onChanged: (int index)=> authController.minTimeChange(time[index]),
                initialPosition: 10,
              ),

              const Text(':', style: robotoBold),

              MinMaxTimePickerWidget(
                times: time, onChanged: (int index)=> authController.maxTimeChange(time[index]),
                initialPosition: 10,
              ),

              MinMaxTimePickerWidget(
                times: unit, onChanged: (int index) => authController.timeUnitChange(unit[index]),
                initialPosition: 1,
              ),

            ]),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: Text(
                '${authController.storeMinTime} - ${authController.storeMaxTime} ${authController.storeTimeUnit}',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              ),
            ),

            CustomButtonWidget(
              width: 200,
              buttonText: 'save'.tr,
              onPressed: (){
                int? min;
                int? max;
                try{
                  min = int.parse(authController.storeMinTime);
                  max = int.parse(authController.storeMaxTime);
                }catch(e){
                  log(e.toString());
                }

                if(min == null){
                  showCustomSnackBar('minimum_delivery_time_can_not_be_empty'.tr);
                }else if(max == null){
                  showCustomSnackBar('maximum_delivery_time_can_not_be_empty'.tr);
                }else if(authController.storeTimeUnit.isEmpty){
                  showCustomSnackBar('time_unit_can_not_be_empty'.tr);
                }else if(min < max){
                  Get.back();
                }else{
                  showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                }
              },
            ),

          ]);
        }),
      ),
    );
  }
}
