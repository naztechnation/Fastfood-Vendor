import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/wallet_payment_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/withdraw_model.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:sixam_mart_store/features/payment/domain/services/payment_service_interface.dart';

class PaymentService implements PaymentServiceInterface {
  final PaymentRepositoryInterface paymentRepositoryInterface;
  PaymentService({required this.paymentRepositoryInterface});

  @override
  Future<bool> updateBankInfo(Map<String, dynamic> body) async {
    return await paymentRepositoryInterface.update(body);
  }

  @override
  Future<List<WithdrawModel>?> getWithdrawList() async {
    return await paymentRepositoryInterface.getList();
  }

  @override
  Future<bool> requestWithdraw(Map<String?, String> data) async {
    return await paymentRepositoryInterface.requestWithdraw(data);
  }

  @override
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    return await paymentRepositoryInterface.getWithdrawMethodList();
  }

  @override
  Future<List<Transactions>?> getWalletPaymentList() async {
    return await paymentRepositoryInterface.getWalletPaymentList();
  }

  @override
  Future<bool> makeWalletAdjustment() async {
    return await paymentRepositoryInterface.makeWalletAdjustment();
  }

  @override
  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName) async {
    return await paymentRepositoryInterface.makeCollectCashPayment(amount, paymentGatewayName);
  }

  @override
  double pendingWithdraw(List<WithdrawModel>? withdrawList) {
    double pendingWithdraw = 0;
    for (var withdraw in withdrawList!) {
      if(withdraw.status == 'Pending') {
        pendingWithdraw = pendingWithdraw + withdraw.amount!;
      }
    }
    return pendingWithdraw;
  }

  @override
  double withdrawn(List<WithdrawModel>? withdrawList) {
    double withdrawn = 0;
    for (var withdraw in withdrawList!) {
      if(withdraw.status == 'Approved') {
        withdrawn = withdrawn + withdraw.amount!;
      }
    }
    return withdrawn;
  }

}