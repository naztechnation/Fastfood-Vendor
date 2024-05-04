import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VariationView extends StatelessWidget {
  final Item item;
  final bool? stock;
  const VariationView({super.key, required this.item, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      (item.variations != null && item.variations!.isNotEmpty) ? Text('variations'.tr, style: robotoMedium) : const SizedBox(),
      SizedBox(height: (item.variations != null && item.variations!.isNotEmpty) ? Dimensions.paddingSizeExtraSmall : 0),

      (item.variations != null && item.variations!.isNotEmpty) ? ListView.builder(
        itemCount: item.variations!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Row(children: [

            Text('${item.variations![index].type!}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverterHelper.convertPrice(item.variations![index].price),
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(width: stock! ? Dimensions.paddingSizeExtraSmall : 0),
            stock! ? Text(
              '(${item.variations![index].stock})',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ) : const SizedBox(),

          ]);
        },
      ) : const SizedBox(),

      SizedBox(height: (item.variations != null && item.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 0),

    ]);
  }
}