import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletWidget extends StatelessWidget {
  final String title;
  final double? value;
  final bool isAmountAndTextInRow;
  const WalletWidget({super.key, required this.title, required this.value, this.isAmountAndTextInRow = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: isAmountAndTextInRow ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, spreadRadius: 0.5, blurRadius: 5)],
      ),
      alignment: Alignment.center,
      child: isAmountAndTextInRow ? Row(children: [

        Text(
          PriceConverterHelper.convertPrice(value), textDirection: TextDirection.ltr,
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),

      ]) : Column(children: [

        Text(
          PriceConverterHelper.convertPrice(value), textDirection: TextDirection.ltr,
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),

      ]),
    );
  }
}
