import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/wallet_payment_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/withdraw_model.dart';

abstract class PaymentServiceInterface {
  Future<bool> updateBankInfo(Map<String, dynamic> body);
  Future<List<WithdrawModel>?> getWithdrawList();
  Future<bool> requestWithdraw(Map<String?, String> data);
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList();
  Future<List<Transactions>?> getWalletPaymentList();
  Future<bool> makeWalletAdjustment();
  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName);
  double pendingWithdraw(List<WithdrawModel>? withdrawList);
  double withdrawn(List<WithdrawModel>? withdrawList);
}