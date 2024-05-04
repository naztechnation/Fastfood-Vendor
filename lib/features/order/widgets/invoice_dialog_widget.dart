import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as i;
import 'package:screenshot/screenshot.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/order/widgets/price_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';

class InvoiceDialog extends StatelessWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  final Function(i.Image? image) onPrint;
  final bool? isPrescriptionOrder;
  final bool paper80MM;
  final double dmTips;
  const InvoiceDialog({super.key, required this.order, required this.orderDetails, required this.onPrint, required this.isPrescriptionOrder, required this.paper80MM, required this.dmTips});

  String _priceDecimal(double price) {
    return price.toStringAsFixed(Get.find<SplashController>().configModel!.digitAfterDecimalPoint!);
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = View.of(context).physicalSize.width > 1000 ? Dimensions.fontSizeExtraSmall : Dimensions.paddingSizeSmall;
    ScreenshotController controller = ScreenshotController();
    Store store = Get.find<ProfileController>().profileModel!.stores![0];

    double itemsPrice = 0;
    double addOns = 0;

    if(isPrescriptionOrder!){
      double orderAmount = order!.orderAmount ?? 0;
      double discount = order!.storeDiscountAmount ?? 0;
      double tax = order!.totalTaxAmount ?? 0;
      double deliveryCharge = order!.deliveryCharge ?? 0;
      itemsPrice = (orderAmount + discount) - (tax + deliveryCharge );
    }
    for(OrderDetailsModel orderDetails in orderDetails!) {
      for(AddOn addOn in orderDetails.addOns!) {
        addOns = addOns + (addOn.price! * addOn.quantity!);
      }
      if(!isPrescriptionOrder!) {
        itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
      }
    }

    return OrientationBuilder(builder: (context, orientation) {
      double fixedSize = View.of(context).physicalSize.width / (orientation == Orientation.portrait ? 720 : 1400);
      double printWidth = (paper80MM ? 280 : 185) / fixedSize;
      bool taxIncluded = order!.taxStatus!;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Screenshot(
            controller: controller,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, spreadRadius: 1, blurRadius: 5)],
              ),
              width: printWidth,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Text(store.name!, style: robotoMedium.copyWith(fontSize: fontSize)),
                Text(store.address!, style: robotoRegular.copyWith(fontSize: fontSize)),
                Text(store.phone!, style: robotoRegular.copyWith(fontSize: fontSize)),
                Text(store.email!, style: robotoRegular.copyWith(fontSize: fontSize)),
                const SizedBox(height: 10),

                Row(children: [
                  Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: fontSize)),
                  const SizedBox(width: 5),
                  Expanded(child: Text(order!.id.toString(), style: robotoMedium.copyWith(fontSize: fontSize))),
                  Text(DateConverterHelper.dateTimeStringToMonthAndTime(order!.createdAt!), style: robotoRegular.copyWith(fontSize: fontSize)),
                ]),
                order!.scheduled == 1 ? Text(
                  '${'scheduled_order_time'.tr} ${DateConverterHelper.dateTimeStringToDateTime(order!.scheduleAt!)}',
                  style: robotoRegular.copyWith(fontSize: fontSize),
                ) : const SizedBox(),
                const SizedBox(height: 5),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(order!.orderType!.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                  Text(order!.paymentMethod!.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                ]),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),

                Align(
                  alignment: Get.find<LocalizationController>().isLtr ? Alignment.topLeft : Alignment.topRight,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(order!.deliveryAddress?.contactPersonName ?? '', style: robotoRegular.copyWith(fontSize: fontSize)),
                    Text(order!.deliveryAddress?.address ?? '', style: robotoRegular.copyWith(fontSize: fontSize)),
                    Text(order!.deliveryAddress?.contactPersonNumber ?? '', style: robotoRegular.copyWith(fontSize: fontSize)),
                  ]),
                ),
                const SizedBox(height: 10),

                Row(children: [
                  Expanded(flex: 1, child: Text('sl'.tr.toUpperCase(), style: robotoMedium.copyWith(fontSize: fontSize))),
                  Expanded(flex: 6, child: Text('item_info'.tr, style: robotoMedium.copyWith(fontSize: fontSize))),
                  Expanded(flex: 1, child: Text(
                    'qty'.tr, style: robotoMedium.copyWith(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(flex: 2, child: Text(
                    'price'.tr, style: robotoMedium.copyWith(fontSize: fontSize),
                    textAlign: TextAlign.right,
                  )),
                ]),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),

                ListView.builder(
                  itemCount: orderDetails!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {

                    String addOnText = '';
                    for (var addOn in orderDetails![index].addOns!) {
                      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
                    }

                    String variationText = '';
                    if(orderDetails![index].variation!.isNotEmpty) {
                      if(orderDetails![index].variation!.isNotEmpty) {
                        List<String> variationTypes = orderDetails![index].variation![0].type!.split('-');
                        if(variationTypes.length == orderDetails![index].itemDetails!.choiceOptions!.length) {
                          int index = 0;
                          for (var choice in orderDetails![index].itemDetails!.choiceOptions!) {
                            variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                            index = index + 1;
                          }
                        }else {
                          variationText = orderDetails![index].itemDetails!.variations![0].type!;
                        }
                      }
                    }else if(orderDetails![index].foodVariation!.isNotEmpty) {
                      for(FoodVariation variation in orderDetails![index].foodVariation!) {
                        variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                        for(VariationValue value in variation.variationValues!) {
                          variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                        }
                        variationText += ')';
                      }
                    }
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 1, child: Text(
                        (index+1).toString(),
                        style: robotoRegular.copyWith(fontSize: fontSize),
                      )),
                      Expanded(flex: 5, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          orderDetails![index].itemDetails!.name!,
                          style: robotoRegular.copyWith(fontSize: fontSize),
                        ),
                        const SizedBox(height: 2),

                        addOnText.isNotEmpty ? Text(
                          '${'addons'.tr}: $addOnText',
                          style: robotoRegular.copyWith(fontSize: fontSize),
                        ) : const SizedBox(),

                        (orderDetails![index].variation != null && orderDetails![index].variation!.isNotEmpty) || (orderDetails![index].foodVariation != null && orderDetails![index].foodVariation!.isNotEmpty) ? Text(
                          '${'variations'.tr}: $variationText',
                          style: robotoRegular.copyWith(fontSize: fontSize),
                        ) : const SizedBox(),

                      ])),
                      Expanded(flex: 2, child: Text(
                        orderDetails![index].quantity.toString(), textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(fontSize: fontSize),
                      )),
                      Expanded(flex: 2, child: Text(
                        _priceDecimal(orderDetails![index].price!), textAlign: TextAlign.right,
                        style: robotoRegular.copyWith(fontSize: fontSize),
                      )),
                    ]);
                  },
                ),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),

                PriceWidget(title: 'item_price'.tr, value: _priceDecimal(itemsPrice), fontSize: fontSize),
                const SizedBox(height: 5),
                addOns > 0 ? PriceWidget(title: 'add_ons'.tr, value: _priceDecimal(addOns), fontSize: fontSize) : const SizedBox(),
                SizedBox(height: addOns > 0 ? 5 : 0),
                PriceWidget(title: '${'subtotal'.tr}${taxIncluded ? '(${'tax_included'.tr})' : ''}', value: _priceDecimal(itemsPrice + addOns), fontSize: fontSize),
                const SizedBox(height: 5),
                PriceWidget(title: 'discount'.tr, value: _priceDecimal(order!.storeDiscountAmount!), fontSize: fontSize),
                const SizedBox(height: 5),
                PriceWidget(title: 'coupon_discount'.tr, value: _priceDecimal(order!.couponDiscountAmount!), fontSize: fontSize),
                const SizedBox(height: 5),
                !taxIncluded ? PriceWidget(title: 'vat_tax'.tr, value: _priceDecimal(order!.totalTaxAmount!), fontSize: fontSize) : const SizedBox(),
                SizedBox(height: taxIncluded ? 0 : 5),
                PriceWidget(title: 'delivery_man_tips'.tr, value: _priceDecimal(dmTips), fontSize: fontSize),
                const SizedBox(height: 5),
                PriceWidget(title: 'delivery_fee'.tr, value: _priceDecimal(order!.deliveryCharge!), fontSize: fontSize),
                SizedBox(height: (order!.additionalCharge != null && order!.additionalCharge! > 0) ? 5 : 0),
                (order!.additionalCharge != null && order!.additionalCharge! > 0)
                    ? PriceWidget(title: Get.find<SplashController>().configModel!.additionalChargeName!, value: _priceDecimal(order!.additionalCharge!), fontSize: fontSize)
                    : const SizedBox(),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),
                PriceWidget(title: 'total_amount'.tr, value: _priceDecimal(order!.orderAmount!), fontSize: fontSize+2),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),

                Text('thank_you'.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                Divider(color: Theme.of(context).textTheme.bodyLarge!.color, thickness: 1),

                Text(
                  '${Get.find<SplashController>().configModel!.businessName}. ${Get.find<SplashController>().configModel!.footerText}',
                  style: robotoRegular.copyWith(fontSize: fontSize),
                ),

              ]),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomButtonWidget(buttonText: 'print_invoice'.tr, height: 40, onPressed: () {
            controller.capture(delay: const Duration(milliseconds: 10)).then((capturedImage) async {
              Get.back();
              onPrint(i.decodeImage(capturedImage!));
            }).catchError((onError) {
              debugPrint(onError);
            });
          }),

        ]),
      );
    });
  }

}