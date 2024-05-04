import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

abstract class CategoryServiceInterface {
  Future<List<CategoryModel>?> getCategoryList();
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID);
  int? categoryIndex(List<CategoryModel>? categoryList, Item? item);
  int? subCategoryIndex(List<CategoryModel>? subCategoryList, Item? item);
}