class BankInfoBodyModel {
  String? bankName;
  String? branch;
  String? holderName;
  String? accountNo;

  BankInfoBodyModel({this.bankName, this.branch, this.holderName, this.accountNo});

  BankInfoBodyModel.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    return data;
  }
}
