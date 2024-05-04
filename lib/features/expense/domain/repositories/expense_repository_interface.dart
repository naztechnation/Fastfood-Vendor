import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class ExpenseRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText});
}