import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/expense/domain/models/expense_model.dart';
import 'package:sixam_mart_store/features/expense/domain/repositories/expense_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class ExpenseRepository implements ExpenseRepositoryInterface {
  final ApiClient apiClient;
  ExpenseRepository({required this.apiClient});

  @override
  Future<ExpenseBodyModel?> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText}) async {
    ExpenseBodyModel? expenseModel;
    Response response = await apiClient.getData('${AppConstants.expenseListUri}?limit=10&offset=$offset&restaurant_id=$restaurantId&from=$from&to=$to&search=${searchText ?? ''}');
    if(response.statusCode == 200){
      expenseModel = ExpenseBodyModel.fromJson(response.body);
    }
    return expenseModel;
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
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}