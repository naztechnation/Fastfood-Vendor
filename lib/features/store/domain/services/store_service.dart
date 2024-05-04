import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/pending_item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/unit_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variant_type_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variation_body_model.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository_interface.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service_interface.dart';

class StoreService implements StoreServiceInterface {
  final StoreRepositoryInterface storeRepositoryInterface;
  StoreService({required this.storeRepositoryInterface});

  @override
  Future<ItemModel?> getItemList(String offset, String type) async {
    return await storeRepositoryInterface.getItemList(offset, type);
  }

  @override
  Future<PendingItemModel?> getPendingItemList(String offset, String type) async {
    return await storeRepositoryInterface.getPendingItemList(offset, type);
  }

  @override
  Future<Item?> getPendingItemDetails(int itemId) async {
    return await storeRepositoryInterface.getPendingItemDetails(itemId);
  }

  @override
  Future<Item?> getItemDetails(int itemId) async {
    return await storeRepositoryInterface.get(itemId);
  }

  @override
  Future<List<AttributeModel>?> getAttributeList(Item? item) async {
    return await storeRepositoryInterface.getAttributeList(item);
  }

  @override
  Future<bool> updateStore(Store store, XFile? logo, XFile? cover, String min, String max, String type, List<Translation> translation) async {
    return await storeRepositoryInterface.updateStore(store, logo, cover, min, max, type, translation);
  }

  @override
  Future<bool> addItem(Item item, XFile? image, List<XFile> images, List<String> savedImages, Map<String, String> attributes, bool isAdd, String tags) async {
    return await storeRepositoryInterface.addItem(item, image, images, savedImages, attributes, isAdd, tags);
  }

  @override
  Future<bool> deleteItem(int? itemID, bool pendingItem) async {
    return await storeRepositoryInterface.deleteItem(itemID, pendingItem);
  }

  @override
  Future<List<ReviewModel>?> getStoreReviewList(int? storeID) async {
    return await storeRepositoryInterface.getStoreReviewList(storeID);
  }

  @override
  Future<List<ReviewModel>?> getItemReviewList(int? itemID) async {
    return await storeRepositoryInterface.getItemReviewList(itemID);
  }

  @override
  Future<bool> updateItemStatus(int? itemID, int status) async {
    return await storeRepositoryInterface.updateItemStatus(itemID, status);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    return await storeRepositoryInterface.add(schedule);
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    return await storeRepositoryInterface.delete(scheduleID);
  }

  @override
  Future<List<UnitModel>?> getUnitList() async {
    return await storeRepositoryInterface.getUnitList();
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    return await storeRepositoryInterface.updateRecommendedProductStatus(productID, status);
  }

  @override
  Future<bool> updateOrganicProductStatus(int? productID, int status) async {
    return await storeRepositoryInterface.updateOrganicProductStatus(productID, status);
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    return await storeRepositoryInterface.updateAnnouncement(status, announcement);
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      pickImage.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickImage;
        }
      });
    }
    return pickImage;
  }

  @override
  bool hasAttributeData(List<AttributeModel>? attributeList){
    bool hasData = false;
    for(AttributeModel attribute in attributeList!) {
      if(attribute.active) {
        hasData = true;
        break;
      }
    }
    return hasData;
  }

  @override
  int setUnitIndex (List<UnitModel>? unitList, Item? item, int unitIndex) {
    int setUnitIndex = unitIndex;
    for(int index = 0; index < unitList!.length; index++) {
      if(item != null) {
        if (unitList[index].unit == item.unitType) {
          setUnitIndex = index + 1;
        }
      }
    }
    return setUnitIndex;
  }

  @override
  List<VariantTypeModel>? variationTypeList(List<AttributeModel>? attributeList, Item? item) {
    List<List<String>> mainList = [];
    int length = 1;
    bool hasData = false;
    List<int> indexList = [];
    List<VariantTypeModel>? variantTypeList = [];
    for (var attribute in attributeList!) {
      if(attribute.active) {
        hasData = true;
        mainList.add(attribute.variants);
        length = length * attribute.variants.length;
        indexList.add(0);
      }
    }
    if(!hasData) {
      length = 0;
    }
    for(int i=0; i<length; i++) {
      String value = '';
      for(int j=0; j<mainList.length; j++) {
        value = value + (value.isEmpty ? '' : '-') + mainList[j][indexList[j]].trim();
      }
      if(item != null && item.variations != null) {
        double? price = 0;
        int? stock = 0;
        for(Variation variation in item.variations!) {
          if(variation.type == value) {
            price = variation.price;
            stock = variation.stock;
            break;
          }
        }
        variantTypeList.add(VariantTypeModel(
          variantType: value, priceController: TextEditingController(text: price! > 0 ? price.toString() : ''), priceNode: FocusNode(),
          stockController: TextEditingController(text: stock! > 0 ? stock.toString() : ''), stockNode: FocusNode(),
        ));
      }else {
        variantTypeList.add(VariantTypeModel(
          variantType: value, priceController: TextEditingController(), priceNode: FocusNode(),
          stockController: TextEditingController(), stockNode: FocusNode(),
        ));
      }

      for(int j=0; j<mainList.length; j++) {
        if(indexList[indexList.length-(1+j)] < mainList[mainList.length-(1+j)].length-1) {
          indexList[indexList.length-(1+j)] = indexList[indexList.length-(1+j)] + 1;
          break;
        }else {
          indexList[indexList.length-(1+j)] = 0;
        }
      }
    }
    return variantTypeList;
  }

  @override
  int totalStock(List<AttributeModel>? attributeList, Item? item) {
    List<List<String>> mainList = [];
    int length = 1;
    bool hasData = false;
    List<int> indexList = [];
    int totalStock = 0;
    for (var attribute in attributeList!) {
      if(attribute.active) {
        hasData = true;
        mainList.add(attribute.variants);
        length = length * attribute.variants.length;
        indexList.add(0);
      }
    }
    if(!hasData) {
      length = 0;
    }
    for(int i=0; i<length; i++) {
      String value = '';
      for(int j=0; j<mainList.length; j++) {
        value = value + (value.isEmpty ? '' : '-') + mainList[j][indexList[j]].trim();
      }
      if(item != null && item.variations != null) {
        int? stock = 0;
        for(Variation variation in item.variations!) {
          if(variation.type == value) {
            stock = variation.stock;
            break;
          }
        }
        totalStock = totalStock + stock!;
      }
      for(int j=0; j<mainList.length; j++) {
        if(indexList[indexList.length-(1+j)] < mainList[mainList.length-(1+j)].length-1) {
          indexList[indexList.length-(1+j)] = indexList[indexList.length-(1+j)] + 1;
          break;
        }else {
          indexList[indexList.length-(1+j)] = 0;
        }
      }
    }
    return totalStock;
  }

  @override
  List<VariationModelBodyModel>? setExistingVariation(List<FoodVariation>? variationList){
    List<VariationModelBodyModel>? variationModelBodyList = [];
    if(variationList != null && variationList.isNotEmpty) {
      for (var variation in variationList) {
        List<Option> options = [];

        for (var option in variation.variationValues!) {
          options.add(Option(
            optionNameController: TextEditingController(text: option.level),
            optionPriceController: TextEditingController(text: option.optionPrice),
          ));
        }

        variationModelBodyList.add(VariationModelBodyModel(
          nameController: TextEditingController(text: variation.name),
          isSingle: variation.type == 'single' ? true : false,
          minController: TextEditingController(text: variation.min),
          maxController: TextEditingController(text: variation.max),
          required: variation.required == 'on' ? true : false,
          options: options,
        ));
      }
    }
    return variationModelBodyList;
  }

}