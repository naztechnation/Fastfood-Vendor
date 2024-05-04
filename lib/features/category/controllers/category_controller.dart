import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  int? _categoryIndex = 0;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex = 0;
  int? get subCategoryIndex => _subCategoryIndex;

  Future<void> getCategoryList(Item? item) async {
    _categoryList = null;
    _categoryIndex = 0;
    List<CategoryModel>? categoryList = await categoryServiceInterface.getCategoryList();
    if (categoryList != null) {
      _categoryList = [];
      _categoryList!.addAll(categoryList);
      _categoryIndex = categoryServiceInterface.categoryIndex(_categoryList, item);
      if(item != null) {
        await getSubCategoryList(int.parse(item.categoryIds![0].id!), item);
      }
    }
    update();
  }

  Future<void> getSubCategoryList(int? categoryID, Item? item) async {
    _subCategoryList = null;
    if(categoryID != 0) {
      _subCategoryIndex = 0;
      List<CategoryModel>? subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
      if (subCategoryList != null) {
        _subCategoryList = [];
        _subCategoryList!.addAll(subCategoryList);
        _subCategoryIndex = categoryServiceInterface.subCategoryIndex(_subCategoryList, item);
      }
    }
    update();
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      update();
    }
  }

}