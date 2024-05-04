import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;
  CategoryRepository({required this.apiClient});

  @override
  Future<List<CategoryModel>?> getList() async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(AppConstants.categoryUri);
    if(response.statusCode == 200) {
      categoryList = [];
      response.body.forEach((category) => categoryList!.add(CategoryModel.fromJson(category)));
    }
    return categoryList;
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if(response.statusCode == 200) {
      subCategoryList = [];
      response.body.forEach((subCategory) => subCategoryList!.add(CategoryModel.fromJson(subCategory)));
    }
    return subCategoryList;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}