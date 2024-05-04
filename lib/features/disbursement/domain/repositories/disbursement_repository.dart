import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:sixam_mart_store/features/disbursement/domain/models/disbursement_method_model.dart' as disburse;
import 'package:sixam_mart_store/features/disbursement/domain/models/disbursement_report_model.dart' as report;
import 'package:sixam_mart_store/util/app_constants.dart';

class DisbursementRepository implements DisbursementRepositoryInterface {
  final ApiClient apiClient;
  DisbursementRepository({required this.apiClient});

  @override
  Future<bool> addWithdraw(Map<String?, String> data) async {
    Response response = await apiClient.postData(AppConstants.addWithdrawMethodUri, data);
    return (response.statusCode == 200);
  }

  @override
  Future<disburse.DisbursementMethodBody?> getList() async {
    disburse.DisbursementMethodBody? disbursementMethodBody;
    Response response = await apiClient.getData('${AppConstants.disbursementMethodListUri}?limit=10&offset=1');
    if(response.statusCode == 200) {
      disbursementMethodBody = disburse.DisbursementMethodBody.fromJson(response.body);
    }
    return disbursementMethodBody;
  }

  @override
  Future<bool> makeDefaultMethod(Map<String?, String> data) async {
    Response response = await apiClient.postData(AppConstants.makeDefaultDisbursementMethodUri, data);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.postData(AppConstants.deleteDisbursementMethodUri, {'_method': 'delete', 'id': id});
    return (response.statusCode == 200);
  }

  @override
  Future<report.DisbursementReportModel?> getDisbursementReport(int offset) async {
    report.DisbursementReportModel? disbursementReportModel;
    Response response = await apiClient.getData('${AppConstants.getDisbursementReportUri}?limit=10&offset=$offset');
    if(response.statusCode == 200) {
      disbursementReportModel = report.DisbursementReportModel.fromJson(response.body);
    }
    return disbursementReportModel;
  }

  @override
  Future add(value) {
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