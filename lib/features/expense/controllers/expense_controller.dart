import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/expense/domain/models/expense_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/features/expense/domain/services/expense_service_interface.dart';

class ExpenseController extends GetxController implements GetxService {
  final ExpenseServiceInterface expenseServiceInterface;
  ExpenseController({required this.expenseServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;
  
  List<String> _offsetList = [];
  
  int _offset = 1;
  int get offset => _offset;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  List<Expense>? _expenses;
  List<Expense>? get expenses => _expenses;
  
  late DateTimeRange _selectedDateRange;
  
  String? _from;
  String? get from => _from;
  
  String? _to;
  String? get to => _to;
  
  String? _searchText;
  String? get searchText => _searchText;
  
  bool _searchMode = false;
  bool get searchMode => _searchMode;

  void initSetDate(){
    _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
    _searchText = '';
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}){
    _searchText = searchText;
    _searchMode = !_searchMode;
    getExpenseList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getExpenseList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _expenses = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ExpenseBodyModel? expenseModel = await expenseServiceInterface.getExpenseList(
        offset: int.parse(offset), from: from, to: to,
        restaurantId: Get.find<ProfileController>().profileModel!.stores![0].id, searchText: searchText,
      );
      if (expenseModel != null) {
        if (offset == '1') {
          _expenses = [];
        }
        _expenses!.addAll(expenseModel.expense!);
        _pageSize = expenseModel.totalSize;
        _isLoading = false;
        update();
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      _selectedDateRange = result;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
      debugPrint('===$from / ===$to');
    }
  }
  
}