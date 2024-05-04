import 'package:get/get.dart';

abstract class PosServiceInterface {
  Future<Response> searchItemList(String searchText);
  Future<Response> searchCustomerList(String searchText);
  Future<Response> placeOrder(String searchText);
  Future<Response> getPosOrders();
}