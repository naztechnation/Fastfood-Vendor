import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCardWidget extends StatelessWidget {
  final String title;
  final String data;
  const ProfileCardWidget({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 850 : 200]!, blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(data, style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(title, style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
        )),
      ]),
    ));
  }
}
