import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/widgets/information_text_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VariationViewForFood extends StatelessWidget {
  final Item item;
  const VariationViewForFood({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? ListView.builder(
      itemCount: item.foodVariations!.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text('${item.foodVariations![index].name!} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
              Text(
                ' ${item.foodVariations![index].type == 'multi' ? 'multiple_select'.tr : 'single_select'.tr}'
                    ' (${item.foodVariations![index].required == 'on' ? 'required'.tr : 'optional'.tr})',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ]),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            ListView.builder(
              itemCount: item.foodVariations![index].variationValues!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i){
                return InformationTextWidget(
                  title: '${item.foodVariations![index].variationValues![i].level}',
                  value: PriceConverterHelper.convertPrice(double.parse(item.foodVariations![index].variationValues![i].optionPrice!)),
                );
              },
            ),

          ]),
        );
      },
    ) : const SizedBox();
  }
}