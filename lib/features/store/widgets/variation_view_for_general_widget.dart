import 'package:flutter/material.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VariationViewForGeneral extends StatelessWidget {
  final Item item;
  final bool? stock;
  const VariationViewForGeneral({super.key, required this.item, required this.stock});

  @override
  Widget build(BuildContext context) {
    return (item.variations != null && item.variations!.isNotEmpty) ? ListView.builder(
      itemCount: item.variations!.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
          color: Theme.of(context).cardColor,
          child: Column(children: [
            Row(children: [
              Expanded(
                flex: 3,
                child: Text(item.variations![index].type!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ),

              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Text(':', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      PriceConverterHelper.convertPrice(item.variations![index].price),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(width: stock! ? Dimensions.paddingSizeExtraSmall : 0),
                    stock! ? Text(
                      '(${item.variations![index].stock})',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ) : const SizedBox(),
                  ],
                ),
              ),

            ]),
          ]),
        );
      },
    ) : const SizedBox();
  }
}