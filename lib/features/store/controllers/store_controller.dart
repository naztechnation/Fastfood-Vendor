import 'dart:convert';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/variant_type_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variation_body_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/pending_item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/unit_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service_interface.dart';

class StoreController extends GetxController implements GetxService {
  final StoreServiceInterface storeServiceInterface;
  StoreController({required this.storeServiceInterface});

  List<Item>? _itemList;
  List<Item>? get itemList => _itemList;

  List<ReviewModel>? _storeReviewList;
  List<ReviewModel>? get storeReviewList => _storeReviewList;

  List<ReviewModel>? _itemReviewList;
  List<ReviewModel>? get itemReviewList => _itemReviewList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<AttributeModel>? _attributeList;
  List<AttributeModel>? get attributeList => _attributeList;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  XFile? _rawLogo;
  XFile? get rawLogo => _rawLogo;

  XFile? _rawCover;
  XFile? get rawCover => _rawCover;

  List<int>? _selectedAddons;
  List<int>? get selectedAddons => _selectedAddons;

  List<VariantTypeModel>? _variantTypeList;
  List<VariantTypeModel>? get variantTypeList => _variantTypeList;

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  List<Schedules>? _scheduleList;
  List<Schedules>? get scheduleList => _scheduleList;

  bool _scheduleLoading = false;
  bool get scheduleLoading => _scheduleLoading;

  bool? _isGstEnabled;
  bool? get isGstEnabled => _isGstEnabled;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  bool _isVeg = false;
  bool get isVeg => _isVeg;

  bool? _isStoreVeg = true;
  bool? get isStoreVeg => _isStoreVeg;

  bool? _isStoreNonVeg = true;
  bool? get isStoreNonVeg => _isStoreNonVeg;

  String _type = 'all';
  String get type => _type;

  static final List<String> _itemTypeList = ['all', 'veg', 'non_veg'];
  List<String> get itemTypeList => _itemTypeList;

  List<UnitModel>? _unitList;
  List<UnitModel>? get unitList => _unitList;

  int _totalStock = 0;
  int get totalStock => _totalStock;

  List<XFile> _rawImages = [];
  List<XFile> get rawImages => _rawImages;

  List<String> _savedImages = [];
  List<String> get savedImages => _savedImages;

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;

  int _unitIndex = 0;
  int get unitIndex => _unitIndex;

  final List<String> _durations = ['min', 'hours', 'days'];
  List<String> get durations => _durations;

  int _durationIndex = 0;
  int get durationIndex => _durationIndex;

  List<VariationModelBodyModel>? _variationList;
  List<VariationModelBodyModel>? get variationList => _variationList;

  List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  bool _isRecommended = false;
  bool get isRecommended => _isRecommended;

  bool _isOrganic = false;
  bool get isOrganic => _isOrganic;

  Item? _item;
  Item? get item => _item;

  List<Items>? _pendingItem;
  List<Items>? get pendingItem => _pendingItem;

  final List<String> _statusList = ['all', 'pending', 'rejected'];
  List<String> get statusList => _statusList;

  int _announcementStatus = 0;
  int get announcementStatus => _announcementStatus;

  int _languageSelectedIndex = 0;
  int get languageSelectedIndex => _languageSelectedIndex;

  void setLanguageSelect(int index) {
    _languageSelectedIndex = index;
    update();
  }

  void setRecommended(bool isRecommended) {
    _isRecommended = isRecommended;
  }

  void setOrganic(bool isOrganic) {
    _isOrganic = isOrganic;
  }

  void toggleRecommendedProduct(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateRecommendedProductStatus(productID, _isRecommended ? 0 : 1);
    if(isSuccess) {
      getItemList('1', 'all');
      _isRecommended = !_isRecommended;
      showCustomSnackBar(Get.find<SplashController>().moduleType == 'food' ? 'food_status_updated_successfully'.tr : 'product_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void toggleOrganicProduct(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateOrganicProductStatus(productID, _isOrganic ? 0 : 1);
    if(isSuccess) {
      getItemList('1', 'all');
      _isOrganic = !_isOrganic;
      showCustomSnackBar(Get.find<SplashController>().moduleType == 'food' ? 'food_status_updated_successfully'.tr : 'product_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setTag(String? name, {bool isUpdate = true, bool isClear = false}){
    if(isClear){
      _tagList = [];
    }else{
      _tagList.add(name);
      if(isUpdate) {
        update();
      }
    }
  }

  void initializeTags(String name){
    _tagList.add(name);
    update();
  }

  void removeTag(int index){
    _tagList.removeAt(index);
    update();
  }

  Future<void> getItemList(String offset, String type) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _itemList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ItemModel? itemModel = await storeServiceInterface.getItemList(offset, type);
      if (itemModel != null) {
        if (offset == '1') {
          _itemList = [];
        }
        _itemList!.addAll(itemModel.items!);
        _pageSize = itemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<Item?> getItemDetails(int itemId) async {
    _isLoading = true;
    update();
    Item? item = await storeServiceInterface.getItemDetails(itemId);
    if (item != null) {
      _item = item;
      _isLoading = false;
      update();
    }
    _isLoading = false;
    update();
    return _item;
  }

  Future<void> getPendingItemList(String offset, String type, {bool canNotify = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _pendingItem = null;
      if(canNotify) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      PendingItemModel? pendingItemModel = await storeServiceInterface.getPendingItemList(offset, type);
      if (pendingItemModel != null) {
        if (offset == '1') {
          _pendingItem = [];
        }
        _pendingItem!.addAll(pendingItemModel.items!);
        _pageSize = pendingItemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }


  Future<bool> getPendingItemDetails(int itemId, {bool canUpdate = true}) async {
    _item = null;
    _languageSelectedIndex = 0;
    bool success = false;
    _isLoading = true;
    if(canUpdate == true) {
      update();
    }
    Item? pendingItem = await storeServiceInterface.getPendingItemDetails(itemId);
    if (pendingItem != null) {
      _item = pendingItem;
      success = true;
    }
    _isLoading = false;
    update();
    return success;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Item? item) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    _rawLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    _totalStock = 0;
    _rawImages = [];
    _savedImages = [];
    if(item != null) {
      _savedImages.addAll(item.images!);
    }
    List<AttributeModel>? attributeList = await storeServiceInterface.getAttributeList(item);
    if(attributeList != null) {
      _attributeList = [];
      _attributeList!.addAll(attributeList);
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.addOn!) {
      List<int?> addonsIds = await Get.find<AddonController>().getAddonList();
      if(item != null && item.addOns != null) {
        for(int index=0; index<item.addOns!.length; index++) {
          setSelectedAddonIndex(addonsIds.indexOf(item.addOns![index].id), false);
        }
      }
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.unit!) {
      await getUnitList(item);
    }
    generateVariantTypes(item);
    await Get.find<CategoryController>().getCategoryList(item);
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void toggleAttribute(int index, Item? product) {
    _attributeList![index].active = !_attributeList![index].active;
    generateVariantTypes(product);
    update();
  }

  void addVariant(int index, String variant, Item? product) {
    _attributeList![index].variants.add(variant);
    generateVariantTypes(product);
    update();
  }

  void removeVariant(int mainIndex, int index, Item? product) {
    _attributeList![mainIndex].variants.removeAt(index);
    generateVariantTypes(product);
    update();
  }

  Future<void> updateStore(Store store, String min, String max, String type, List<Translation> translation) async {
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.updateStore(store, _rawLogo, _rawCover, min, max, type, translation);
    if(isSuccess) {
      await Get.find<ProfileController>().getProfile();
      Get.find<StoreController>().getItemList('1', 'all');
      Get.find<StoreController>().getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id);
      showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
          ? 'restaurant_settings_updated_successfully'.tr : 'store_settings_updated_successfully'.tr, isError: false);
      Get.offAllNamed(RouteHelper.getMainRoute('cart'));
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _rawLogo = null;
      _rawCover = null;
    }else {
      isLogo ? _rawLogo = await storeServiceInterface.pickImageFromGallery() : _rawCover = await storeServiceInterface.pickImageFromGallery();
      update();
    }
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons!.contains(index)) {
      _selectedAddons!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons!.removeAt(index);
    update();
  }

  Future<void> addItem(Item item, bool isAdd) async {
    _isLoading = true;
    update();
    Map<String, String> fields = {};
    if(!Get.find<SplashController>().getStoreModuleConfig().newVariation! && _variantTypeList!.isNotEmpty) {
      List<int?> idList = [];
      List<String?> nameList = [];
      for (var attributeModel in _attributeList!) {
        if(attributeModel.active) {
          idList.add(attributeModel.attribute.id);
          nameList.add(attributeModel.attribute.name);
          String variantString = '';
          for (var variant in attributeModel.variants) {
            variantString = variantString + (variantString.isEmpty ? '' : ',') + variant.replaceAll(' ', '');
          }
          fields.addAll(<String, String>{'choice_options_${attributeModel.attribute.id}': jsonEncode([variantString])});
        }
      }
      fields.addAll(<String, String> {
        'attribute_id': jsonEncode(idList), 'choice_no': jsonEncode(idList), 'choice': jsonEncode(nameList)
      });
      for(int index=0; index<_variantTypeList!.length; index++) {
        fields.addAll(<String, String> {'price_${_variantTypeList![index].variantType.replaceAll(' ', '_')}': _variantTypeList![index].priceController.text.trim(),
          'stock_${_variantTypeList![index].variantType.replaceAll(' ', '_')}': _variantTypeList![index].stockController.text.trim().isEmpty ? '0'
              : _variantTypeList![index].stockController.text.trim()});
      }
    }
    String tags = '';
    for (var element in _tagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }
    bool isSuccess = await storeServiceInterface.addItem(item, _rawLogo, _rawImages, _savedImages, fields, isAdd, tags);
    if(isSuccess) {
      // Get.offAllNamed(RouteHelper.getInitialRoute());
      Get.offAll(() => const DashboardScreen(pageIndex: 2));
      showCustomSnackBar(isAdd ? 'the_product_will_be_published_once_it_receives_approval_from_the_admin'.tr : 'your_product_added_for_approval'.tr, isError: false);
      _tagList.clear();
      getItemList('1', 'all');
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteItem(int? itemID, {bool pendingItem = false}) async {
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.deleteItem(itemID, pendingItem);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      if(pendingItem) {
        getPendingItemList(offset.toString(), type);
      }else {
        getItemList('1', 'all');
      }
    }
    _isLoading = false;
    update();
  }

  void generateVariantTypes(Item? item) {
    _variantTypeList = storeServiceInterface.variationTypeList(_attributeList, item);
    _totalStock = storeServiceInterface.totalStock(_attributeList, item);
  }

  bool hasAttribute() {
    bool hasData = storeServiceInterface.hasAttributeData(_attributeList);
    return hasData;
  }

  Future<void> getStoreReviewList(int? storeID) async {
    _tabIndex = 0;
    List<ReviewModel>? storeReviewList = await storeServiceInterface.getStoreReviewList(storeID);
    if(storeReviewList != null) {
      _storeReviewList = [];
      _storeReviewList!.addAll(storeReviewList);
    }
    update();
  }

  Future<void> getItemReviewList(int? itemID) async {
    _itemReviewList = null;
    List<ReviewModel>? itemReviewList = await storeServiceInterface.getItemReviewList(itemID);
    if(itemReviewList != null) {
      _itemReviewList = [];
      _itemReviewList!.addAll(itemReviewList);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateItemStatus(productID, _isAvailable ? 0 : 1);
    if(isSuccess) {
      getItemList('1', 'all');
      _isAvailable = !_isAvailable;
      showCustomSnackBar('item_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void initStoreData(Store store) {
    _rawLogo = null;
    _rawCover = null;
    _isGstEnabled = store.gstStatus;
    _scheduleList = [];
    _scheduleList!.addAll(store.schedules!);
    _isStoreVeg = store.veg == 1;
    _isStoreNonVeg = store.nonVeg == 1;
  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled!;
    update();
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = '${schedule.openingTime!}:00';
    schedule.closingTime = '${schedule.closingTime!}:00';
    _scheduleLoading = true;
    update();
    int? scheduleID = await storeServiceInterface.addSchedule(schedule);
    if(scheduleID != null) {
      schedule.id = scheduleID;
      _scheduleList!.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int? scheduleID) async {
    _scheduleLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.deleteSchedule(scheduleID);
    if(isSuccess) {
      _scheduleList!.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool notify = true;
    if(_tabIndex == index) {
      notify = false;
    }
    _tabIndex = index;
    if(notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setStoreVeg(bool? isVeg, bool notify) {
    _isStoreVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setStoreNonVeg(bool? isNonVeg, bool notify) {
    _isStoreNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

  Future<void> getUnitList(Item? item) async {
    _unitIndex = 0;
    List<UnitModel>? unitList = await storeServiceInterface.getUnitList();
    if(unitList != null) {
      _unitList = [];
      _unitList!.addAll(unitList);
      _unitIndex = storeServiceInterface.setUnitIndex(_unitList, item, _unitIndex);
    }
    update();
  }

  void setTotalStock() {
    _totalStock = 0;
    for (var variant in _variantTypeList!) {
      _totalStock = variant.stockController.text.trim().isNotEmpty ? _totalStock + int.parse(variant.stockController.text.trim()) : _totalStock;
    }
    update();
  }

  void pickImages() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(xFile != null) {
      _rawImages.add(xFile);
    }
    update();
  }

  void removeImage(int index) {
    _rawImages.removeAt(index);
    update();
  }

  void removeSavedImage(int index) {
    _savedImages.removeAt(index);
    update();
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      update();
    }
  }

  void setDurationType(int index, bool notify) {
    _durationIndex = index;
    if(notify) {
      update();
    }
  }

  void setEmptyVariationList(){
    _variationList = [];
  }

  void setExistingVariation(List<FoodVariation>? variationList) {
    _variationList = storeServiceInterface.setExistingVariation(variationList);
  }

  void changeSelectVariationType(int index) {
    _variationList![index].isSingle = !_variationList![index].isSingle;
    update();
  }

  void setVariationRequired(int index) {
    _variationList![index].required = !_variationList![index].required;
    update();
  }

  void addVariation() {
    _variationList!.add(VariationModelBodyModel(
      nameController: TextEditingController(), required: false, isSingle: true, maxController: TextEditingController(), minController: TextEditingController(),
      options: [Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController())],
    ));
    update();
  }

  void removeVariation(int index) {
    _variationList!.removeAt(index);
    update();
  }

  void addOptionVariation(int index) {
    _variationList![index].options!.add(Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController()));
    update();
  }

  void removeOptionVariation(int vIndex, int oIndex) {
    _variationList![vIndex].options!.removeAt(oIndex);
    update();
  }

  Future<void> updateAnnouncement(int status, String announcement) async{
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.updateAnnouncement(status, announcement);
    if(isSuccess){
      Get.back();
      showCustomSnackBar('announcement_updated_successfully'.tr, isError: false);
      Get.find<ProfileController>().getProfile();
    }
    _isLoading = false;
    update();
  }

  void setAnnouncementStatus(int index){
    _announcementStatus = index;
    update();
  }

  bool isFoodModule() {
    final profileModel = Get.find<ProfileController>().profileModel;
    return profileModel?.stores?.first.module?.moduleType == AppConstants.food;
  }

}