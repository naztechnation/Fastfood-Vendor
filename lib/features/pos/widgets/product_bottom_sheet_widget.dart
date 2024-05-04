import 'package:sixam_mart_store/common/widgets/rating_bar_widget.dart';
import 'package:sixam_mart_store/features/pos/controllers/pos_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/pos/domain/models/cart_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/discount_tag_widget.dart';
import 'package:sixam_mart_store/features/pos/widgets/quantity_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemBottomSheetWidget extends StatelessWidget {
  final Item? item;
  final bool isCampaign;
  final CartModel? cart;
  final int? cartIndex;
  const ItemBottomSheetWidget({super.key, required this.item, this.isCampaign = false, this.cart, this.cartIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool fromCart = cart != null;
    Get.find<PosController>().initData(item, cart);

    return Container(
      width: 550,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<PosController>(builder: (posController) {
        double? startingPrice;
        double? endingPrice;
        if (item!.choiceOptions!.isNotEmpty) {
          List<double?> priceList = [];
          for (var variation in item!.variations!) {
            priceList.add(variation.price);
          }
          priceList.sort((a, b) => a!.compareTo(b!));
          startingPrice = priceList[0];
          if (priceList[0]! < priceList[priceList.length - 1]!) {
            endingPrice = priceList[priceList.length - 1];
          }
        } else {
          startingPrice = item!.price;
        }

        List<String> variationList = [];
        for (int index = 0; index < item!.choiceOptions!.length; index++) {
          variationList.add(item!.choiceOptions![index].options![posController.variationIndex![index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        for (var variation in variationList) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        }

        double? price = item!.price;
        Variation? variation;
        for (Variation variationItem in item!.variations!) {
          if (variationItem.type == variationType) {
            price = variationItem.price;
            variation = variationItem;
            break;
          }
        }

        double? discount = (isCampaign || item!.storeDiscount == 0) ? item!.discount : item!.storeDiscount;
        String? discountType = (isCampaign || item!.storeDiscount == 0) ? item!.discountType : 'percent';
        double priceWithDiscount = PriceConverterHelper.convertWithDiscount(price, discount, discountType)!;
        double priceWithQuantity = priceWithDiscount * posController.quantity!;
        double addonsCost = 0;
        List<AddOn> addOnIdList = [];
        List<AddOns> addOnsList = [];
        for (int index = 0; index < item!.addOns!.length; index++) {
          if (posController.addOnActiveList[index]) {
            addonsCost = addonsCost + (item!.addOns![index].price! * posController.addOnQtyList[index]!);
            addOnIdList.add(AddOn(id: item!.addOns![index].id, quantity: posController.addOnQtyList[index]));
            addOnsList.add(item!.addOns![index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        bool isAvailable = DateConverterHelper.isAvailable(item!.availableTimeStarts, item!.availableTimeEnds);

        CartModel cartModel = CartModel(
          price: price, discountedPrice: priceWithDiscount, variation: variation != null ? [variation] : [],
          discountAmount: (price! - PriceConverterHelper.convertWithDiscount(price, discount, discountType)!), item: item,
          quantity: posController.quantity, addOnIds: addOnIdList, addOns: addOnsList, isCampaign: isCampaign,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            ResponsiveHelper.isDesktop(context) ? InkWell(onTap: () => Get.back(), child: const Icon(Icons.close)) : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.paddingSizeDefault, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                //Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${isCampaign ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl
                            : Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${item!.image}',
                        width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTagWidget(discount: discount, discountType: discountType, fromTop: 20),
                  ]),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        item!.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      RatingBarWidget(rating: item!.avgRating, size: 15, ratingCount: item!.ratingCount),
                      const SizedBox(height: 5),
                      Text(
                        '${PriceConverterHelper.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                            '${endingPrice != null ? ' - ${PriceConverterHelper.convertPrice(endingPrice, discount: discount,
                            discountType: discountType)}' : ''}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(height: 5),
                      price > priceWithDiscount ? Text(
                        '${PriceConverterHelper.convertPrice(startingPrice)}'
                            '${endingPrice != null ? ' - ${PriceConverterHelper.convertPrice(endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                      ) : const SizedBox(),
                    ]),
                  ),
                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                (item!.description != null && item!.description!.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(item!.description!, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ],
                ) : const SizedBox(),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: item!.choiceOptions!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item!.choiceOptions![index].title!, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 0.25),
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item!.choiceOptions![index].options!.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              posController.setCartVariationIndex(index, i);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: posController.variationIndex![index] != i ? Theme.of(context).disabledColor.withOpacity(0.2)
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: posController.variationIndex![index] != i
                                    ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                              ),
                              child: Text(
                                item!.choiceOptions![index].options![i].trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  color: posController.variationIndex![index] != i ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: index != item!.choiceOptions!.length - 1 ? Dimensions.paddingSizeLarge : 0),
                    ]);
                  },
                ),
                item!.choiceOptions!.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  const Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButtonWidget(
                      onTap: () {
                        if (posController.quantity! > 1) {
                          posController.setProductQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(posController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    QuantityButtonWidget(
                      onTap: () => posController.setProductQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Addons
                item!.addOns!.isNotEmpty ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('addons'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item!.addOns!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!posController.addOnActiveList[index]) {
                            posController.addAddOn(true, index);
                          } else if (posController.addOnQtyList[index] == 1) {
                            posController.addAddOn(false, index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: posController.addOnActiveList[index] ? 2 : 20),
                          decoration: BoxDecoration(
                            color: posController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: posController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                            boxShadow: posController.addOnActiveList[index]
                            ? Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, blurRadius: 5, spreadRadius: 1)] : null,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(item!.addOns![index].name!,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  PriceConverterHelper.convertPrice(item!.addOns![index].price),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                                ),
                              ]),
                            ),
                            posController.addOnActiveList[index] ? Container(
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (posController.addOnQtyList[index]! > 1) {
                                        posController.setAddOnQuantity(false, index);
                                      } else {
                                        posController.addAddOn(false, index);
                                      }
                                    },
                                    child: const Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(
                                  posController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => posController.setAddOnQuantity(true, index),
                                    child: const Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                                : const SizedBox(),
                          ]),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ]) : const SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(PriceConverterHelper.convertPrice(priceWithAddons), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                //Add to cart Button

                isAvailable ? const SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverterHelper.convertStringTimeToTime(item!.availableTimeStarts!)} '
                          '- ${DateConverterHelper.convertStringTimeToTime(item!.availableTimeEnds!)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!item!.scheduleOrder! && !isAvailable) ? const SizedBox() : CustomButtonWidget(
                  width: ResponsiveHelper.isDesktop(context) ? size.width / 2.0 : null,
                  /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                      ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                  buttonText: isCampaign ? 'order_now'.tr : fromCart ? 'update'.tr : 'add'.tr,
                  onPressed: () {
                    Get.back();
                    if(isCampaign) {

                    }else {
                      Get.find<PosController>().addToCart(cartModel, cartIndex);
                      showCustomSnackBar(fromCart ? 'item_updated'.tr : 'item_added'.tr, isError: false);
                    }
                  },

                ),
              ]),
            ),
          ]),
        );
      }),
    );
  }
}

