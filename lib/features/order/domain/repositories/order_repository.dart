import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/update_status_body_model.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<OrderModel>?> getList() async {
    List<OrderModel>? runningOrderList;
    Response response = await apiClient.getData(AppConstants.currentOrdersUri);
    if (response.statusCode == 200) {
      runningOrderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        runningOrderList!.add(orderModel);
      });
    }
    return runningOrderList;
  }

  @override
  Future<PaginatedOrderModel?> getPaginatedOrderList(int offset, String status) async {
    PaginatedOrderModel? historyOrderModel;
    Response response = await apiClient.getData('${AppConstants.completedOrdersUri}?status=$status&offset=$offset&limit=10');
    if (response.statusCode == 200) {
      historyOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return historyOrderModel;
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusBodyModel updateStatusBody, List<MultipartBody> proofAttachment) async {
    ResponseModel responseModel;
    Response response = await apiClient.postMultipartData(AppConstants.updatedOrderStatusUri, updateStatusBody.toJson(), proofAttachment, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<List<OrderDetailsModel>?> getOrderDetails(int orderID) async {
    List<OrderDetailsModel>? orderDetailsModel;
    Response response = await apiClient.getData('${AppConstants.orderDetailsUri}$orderID');
    if(response.statusCode == 200) {
      orderDetailsModel = [];
      response.body.forEach((orderDetails) => orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
    }
    return orderDetailsModel;
  }

  @override
  Future<OrderModel?> get(int? id) async {
    OrderModel? orderModel;
    Response response = await apiClient.getData('${AppConstants.currentOrderDetailsUri}$id');
    if (response.statusCode == 200) {
      orderModel = OrderModel.fromJson(response.body);
    }
    return orderModel;
  }

  @override
  Future<ResponseModel> update(Map<String, dynamic> body) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.updateOrderUri, body, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<OrderCancellationBodyModel?> getCancelReasons() async {
    OrderCancellationBodyModel? orderCancellationBody;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=store');
    if (response.statusCode == 200) {
      orderCancellationBody = OrderCancellationBodyModel.fromJson(response.body);
    }
    return orderCancellationBody;
  }

  @override
  Future<bool> sendDeliveredNotification(int? orderID) async {
    Response response = await apiClient.postData(AppConstants.deliveredOrderNotificationUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID});
    return (response.statusCode == 200);
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

}