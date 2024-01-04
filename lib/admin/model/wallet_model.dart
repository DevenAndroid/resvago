class WithdrawMoneyModel {
  dynamic amount;
  dynamic time;
  String? userId;
  String? status;
  dynamic docid;

  WithdrawMoneyModel({this.amount, this.time, this.userId, this.status,this.docid});

  WithdrawMoneyModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    time = json['time'];
    userId = json['userId'];
    status = json['status'];
    docid = json['docid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['time'] = time;
    data['userId'] = userId;
    data['status'] = status;
    data['docid'] = docid;
    return data;
  }
}
