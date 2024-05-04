import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/expense/domain/models/expense_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ExpenseCardWidget extends StatelessWidget {
  final Expense expense;
  const ExpenseCardWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, offset: const Offset(0, 5), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('${'order_id'.tr}: #${expense.orderId}', style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        const Divider(),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            DateConverterHelper.dateTimeStringToDateTime(expense.createdAt!),
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
          Text('amount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text('${'expense_type'.tr} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            Text(expense.type!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
          ]),
          Text(PriceConverterHelper.convertPrice(expense.amount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,)),
        ]),
      ]),
    );
  }
}
