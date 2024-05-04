import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

abstract class StoreRepositoryInterface<T> extends RepositoryInterface<Schedules> {
  Future<dynamic> getItemList(String offset, String type);
  Future<dynamic> getPendingItemList(String offset, String type);
  Future<dynamic> getPendingItemDetails(int itemId);
  Future<dynamic> getAttributeList(Item? item);
  Future<dynamic> updateStore(Store store, XFile? logo, XFile? cover, String min, String max, String type, List<Translation> translation);
  Future<dynamic> addItem(Item item, XFile? image, List<XFile> images, List<String> savedImages, Map<String, String> attributes, bool isAdd, String tags);
  Future<dynamic> deleteItem(int? itemID, bool pendingItem);
  Future<dynamic> getStoreReviewList(int? storeID);
  Future<dynamic> getItemReviewList(int? itemID);
  Future<dynamic> updateItemStatus(int? itemID, int status);
  Future<dynamic> getUnitList();
  Future<dynamic> updateRecommendedProductStatus(int? productID, int status);
  Future<dynamic> updateOrganicProductStatus(int? productID, int status);
  Future<dynamic> updateAnnouncement(int status, String announcement);
}