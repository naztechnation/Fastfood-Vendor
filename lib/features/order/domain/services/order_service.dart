import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/update_status_body_model.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart_store/features/order/domain/services/order_service_interface.dart';

class OrderService implements OrderServiceInterface {
  final OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future<List<OrderModel>?> getCurrentOrders() async {
    return await orderRepositoryInterface.getList();
  }

  @override
  Future<PaginatedOrderModel?> getPaginatedOrderList(int offset, String status) async {
    return await orderRepositoryInterface.getPaginatedOrderList(offset, status);
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusBodyModel updateStatusBody, List<MultipartBody> proofAttachment) async {
    return await orderRepositoryInterface.updateOrderStatus(updateStatusBody, proofAttachment);
  }

  @override
  Future<List<OrderDetailsModel>?> getOrderDetails(int orderID) async {
    return await orderRepositoryInterface.getOrderDetails(orderID);
  }

  @override
  Future<OrderModel?> getOrderWithId(int orderId) async {
    return await orderRepositoryInterface.get(orderId);
  }

  @override
  Future<ResponseModel> updateOrderAmount(Map<String, String> body) async {
    return await orderRepositoryInterface.update(body);
  }

  @override
  Future<OrderCancellationBodyModel?> getCancelReasons() async {
    return await orderRepositoryInterface.getCancelReasons();
  }

  @override
  Future<bool> sendDeliveredNotification(int? orderID) async {
    return await orderRepositoryInterface.sendDeliveredNotification(orderID);
  }

  @override
  List<MultipartBody> processMultipartData(List<XFile> pickedPrescriptions) {
    List<MultipartBody> multiParts = [];
    for(XFile file in pickedPrescriptions) {
      multiParts.add(MultipartBody('order_proof[]', file));
    }
    return multiParts;
  }

}