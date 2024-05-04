import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository_interface.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface categoryRepositoryInterface;
  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<List<CategoryModel>?> getCategoryList() async {
    return await categoryRepositoryInterface.getList();
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID) async {
    return await categoryRepositoryInterface.getSubCategoryList(parentID);
  }

  @override
  int? categoryIndex(List<CategoryModel>? categoryList, Item? item) {
    int? categoryIndex = 0;
    for(int index = 0; index < categoryList!.length; index++) {
      if(item != null) {
        if(categoryList[index].id.toString() == item.categoryIds![0].id) {
          categoryIndex = index + 1;
        }
      }
    }
    return categoryIndex;
  }

  @override
  int? subCategoryIndex(List<CategoryModel>? subCategoryList, Item? item) {
    int? subCategoryIndex = 0;
    for(int index = 0; index < subCategoryList!.length; index++) {
      if(item != null && item.categoryIds!.length > 1) {
        if(subCategoryList[index].id.toString() == item.categoryIds![1].id) {
          subCategoryIndex = index + 1;
        }
      }
    }
    return subCategoryIndex;
  }

}