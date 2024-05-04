import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/pending_item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/unit_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variant_type_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variation_body_model.dart';

abstract class StoreServiceInterface {
  Future<ItemModel?> getItemList(String offset, String type);
  Future<PendingItemModel?> getPendingItemList(String offset, String type);
  Future<Item?> getPendingItemDetails(int itemId);
  Future<Item?> getItemDetails(int itemId);
  Future<List<AttributeModel>?> getAttributeList(Item? item);
  Future<bool> updateStore(Store store, XFile? logo, XFile? cover, String min, String max, String type, List<Translation> translation);
  Future<bool> addItem(Item item, XFile? image, List<XFile> images, List<String> savedImages, Map<String, String> attributes, bool isAdd, String tags);
  Future<bool> deleteItem(int? itemID, bool pendingItem);
  Future<List<ReviewModel>?> getStoreReviewList(int? storeID);
  Future<List<ReviewModel>?> getItemReviewList(int? itemID);
  Future<bool> updateItemStatus(int? itemID, int status);
  Future<int?> addSchedule(Schedules schedule);
  Future<bool> deleteSchedule(int? scheduleID);
  Future<List<UnitModel>?> getUnitList();
  Future<bool> updateRecommendedProductStatus(int? productID, int status);
  Future<bool> updateOrganicProductStatus(int? productID, int status);
  Future<bool> updateAnnouncement(int status, String announcement);
  Future<XFile?> pickImageFromGallery();
  bool hasAttributeData(List<AttributeModel>? attributeList);
  int setUnitIndex (List<UnitModel>? unitList, Item? item, int unitIndex);
  List<VariantTypeModel>? variationTypeList(List<AttributeModel>? attributeList, Item? item);
  int totalStock(List<AttributeModel>? attributeList, Item? item);
  List<VariationModelBodyModel>? setExistingVariation(List<FoodVariation>? variationList);
}